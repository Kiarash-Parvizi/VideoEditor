#include "vprocess.h"

#include<QSet>
#include<CmdExecution.h>

VChunk::VChunk() {}

VChunk::VChunk(int idx, const QString& vid_src, ll vStart, ll vEnd,
               const QString& aud_src, ll aStart, ll aEnd, bool hasAudio, const QVector<Effect*>& efct)
    : idx(idx)
    , vid_src(vid_src)
    , vStart(vStart)
    , vEnd(vEnd)
    , aud_src(aud_src)
    , aStart(aStart)
    , aEnd(aEnd)
    , hasAudio(hasAudio)
{
    for (auto ef : efct) {
        this->effects.push_back(ef->clone());
        qDebug() << ":->" << effects[effects.size()-1]->get_command(1,1);
    }
}

VChunk::~VChunk() {
    for (const auto efc : effects) {
        //delete efc;
    }
}

QString VChunk::get_command(const QMap<QString, int>& map_name_id, const QString& scaleStr, const QString& darStr) const {
    QString ret;
    ret += QString("[") + QString::number(map_name_id[vid_src]) + ":v]" +
        "trim=start="+QString::number(vStart)+"ms:end="+QString::number(vEnd)+
        "ms,scale="+scaleStr+",setdar="+darStr+",setpts=PTS-STARTPTS[v"+QString::number(idx)+"]";
    int i = 0; for (auto efc : effects) {
        qDebug() << ".";
        ret += QString(";") + efc->get_command(idx, i);
    ++i; }
    QString audioStateCmd = hasAudio ? "" : ",volume=volume=0";
    ret += QString(";[")+QString::number(map_name_id[aud_src])+":a]atrim=start="+
            QString::number(aStart)+"ms:end="+QString::number(aEnd)+"ms,asetpts=PTS-STARTPTS"+
            audioStateCmd+"[a"+QString::number(idx)+"]";
    return ret;
}

QString VChunk::get_finalVOut() const {
    if (effects.size()) {
        return QString("v") + QString::number(idx) + "_" + QString::number(effects.size()-1);
    } else {
        return QString("v") + QString::number(idx);
    }
}

QString VChunk::get_finalAOut() const {
    return QString("a") + QString::number(idx);
}
// ----------------

VProcess::VProcess(TimeLine *timeline, QObject* parent)
    : QObject(parent)
    , timeline(timeline)
{
}

void VProcess::exportVideo(const QString& finalFFCommand) {
    // reset
    reset();
    // vchunk-processing
    calc_vchuncks();
    // err-check
    if (!vchunks.size()) {
        qDebug() << "ERROR: nothing to export";
        return;
    }
    // command
    auto ffCommand = gen_ff_command(finalFFCommand);
    // exe
    qDebug() << "COMMAND: " << (ffCommand.toUtf8() + " && Pause").constData();
    //system("cmd.exe /c dir c:\\");
    exec((ffCommand.toUtf8()).constData());
}

void VProcess::set_ffPath(const QString &path) {
    for (QChar c : path) {
        if (c == " ") {
            qDebug() << "ERROR: Invalid ffpath -> path contains white-spaces";
            return;
        }
    }
    ffPath = path;
}

void VProcess::set_scaleStr(const QString &scaleStr) {
    this->scaleStr = scaleStr;
}

void VProcess::set_darStr(const QString &darStr) {
    this->darStr = darStr;
}

void VProcess::reset() {
    map_name_id.clear();
    vchunks.clear();
}

void VProcess::register_data(const QString &src) {
    if (!map_name_id.contains(src)) {
        map_name_id[src] = map_name_id.size();
    }
}

void VProcess::calc_vchunks_fromVidItems() {
    vchunks.reserve(timeline->model->getModelVec()->size());
    int i = 0;for(const auto& v : *timeline->model->getModelVec()) {
        vchunks.push_back(VChunk(i, v._source, v.start, v.end, v._source, v.start, v.end, v.hasAudio, v.effects));
    ++i;}
    qDebug() << "V->";
    for (int i = 0; i < vchunks.size(); i++) {
        for (int j = 0; j < vchunks[i].effects.size(); j++) {
            qDebug() << "V->E :" << vchunks[i].aEnd;
            qDebug() << "V->EF: " << vchunks[i].effects[j]->get_command(2,2);
        }
    }
}

void VProcess::merge_vchunks_aaudio() {
    for (const auto& v : *timeline->aModel->getModelVec()) {
    }
}

void VProcess::calc_vchuncks() {
    calc_vchunks_fromVidItems();
    merge_vchunks_aaudio();
}

QString VProcess::gen_init_command() {
    QString ret = ffPath + " -y ";
    QSet<QString> Set;
    for (const auto& v : vchunks) {
        Set.insert(v.vid_src);
        Set.insert(v.aud_src);
    }
    // command
    for (const auto& src : Set) {
        ret += "-i \"" + src + "\" ";
        register_data(src);
    }
    ret += "-filter_complex ";
    return ret;
}

QString VProcess::gen_process_command() {
    QString ret;
    for (const auto& v : vchunks) {
        ret += v.get_command(map_name_id, scaleStr, darStr) + ";";
    }
    return ret;
}

QString VProcess::gen_concat_command() {
    QString ret, vList, aList;
    for (const auto& v : vchunks) {
        vList += QString("[") + v.get_finalVOut() + "]";
        aList += QString("[") + v.get_finalAOut() + "]";
    }
    ret = vList + "concat=n="+QString::number(vchunks.size())+":v=1:a=0[outv];" +
          aList + "concat=n="+QString::number(vchunks.size())+":v=0:a=1[outa]";
    return ret;
}

QString VProcess::gen_ff_command(const QString& finalFFCommand) {
    auto init_command = gen_init_command();
    auto process_command = gen_process_command();
    auto concat_command = gen_concat_command();
    return init_command + "\"" + process_command + concat_command + "\" " + finalFFCommand;
}
