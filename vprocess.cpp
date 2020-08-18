#include "vprocess.h"

#include<QSet>

VChunk::VChunk() {}

VChunk::VChunk(int idx, const QString& vid_src, ll vStart, ll vEnd,
               const QString& aud_src, ll aStart, ll aEnd, const QVector<Effect*> efct)
    : idx(idx)
    , vid_src(vid_src)
    , vStart(vStart)
    , vEnd(vEnd)
    , aud_src(aud_src)
    , aStart(aStart)
    , aEnd(aEnd)
    , effects(efct.size())
{
    int i = 0; for (const auto ef : efct) {
        effects[i] = ef->clone();
    i++; }
}

VChunk::~VChunk() {
    for (const auto efc : effects) {
        delete efc;
    }
}

QString VChunk::get_command(const QMap<QString, int>& map_name_id) const {
    QString ret = QString("[") + QString::number(map_name_id[vid_src]) + ":v]" +
        "trim=start="+QString::number(vStart)+"ms:end="+QString::number(vEnd)+
        "ms,setpts=PTS-STARTPTS[v"+QString::number(idx)+"]";
    int i = 0; for (const auto efc : effects) {
        ret += efc->get_command(idx, i);
    ++i; }
    ret += QString(";[")+QString::number(map_name_id[aud_src])+":a]atrim=start="+
            QString::number(aStart)+"ms:end="+QString::number(aEnd)+"ms,asetpts=PTS-STARTPTS[a"+QString::number(idx)+"]";
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

void VProcess::ExportVideo(const QString& finalFFCommand) {
    // reset
    reset();
    // vchunk-processing
    calc_vchuncks();
    // command
    auto ffCommand = gen_ff_command(finalFFCommand);
    // exe
    system(ffCommand.toUtf8().constData());
}

void VProcess::reset() {
    vchunks.clear();
}

void VProcess::register_data(const QString &src) {
    if (!map_name_id.contains(src)) {
        map_name_id[src] = map_name_id.size();
    }
}

void VProcess::calc_vchunks_fromVidItems() {
}

void VProcess::merge_vchunks_aaudio() {
}

void VProcess::calc_vchuncks() {
    calc_vchunks_fromVidItems();
    merge_vchunks_aaudio();
}

QString VProcess::gen_init_command() {
    QString ret = "ffmpeg ";
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
        ret += v.get_command(map_name_id) + ";";
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
