#include "timeline.h"
#include<cmath>
#include<functional>

TimeLine::TimeLine(TVideo_Model* model, TAudio_Model* aModel, QObject* parent)
    : QObject(parent)
    , model(model)
    , aModel(aModel)
{
    connect(model, &TVideo_Model::changed_totalTime, this, &TimeLine::slot_totalVidLen);
    connect(model, &TVideo_Model::changed_totalTime, aModel, &TAudio_Model::set_totalVideoLen);
    model->set_emitStateChanged_func(std::bind(&TimeLine::stateChanged, this));
}

ll TimeLine::get_totalVidLen() {
    return model->get_totalTime();
}

void TimeLine::slot_totalVidLen() {
    qDebug() << "totalVidLen changed";
    emit changed_totalVidLen();
}

QAbstractListModel* TimeLine::get_model() {
    return model;
}

QAbstractListModel *TimeLine::get_aModel() {
    return aModel;
}

double TimeLine::calc_width(ll len, int winWidth) {
    qDebug() << "calc_width";
    return ((double)winWidth * ((double)len/(double)get_totalVidLen()));
}

void TimeLine::ins_Buf(const QString& source, ll start, ll end, ll vTime) {
    model->Insert_Buf({source, end-start, start, end, true}, vTime);
}

void TimeLine::del_VBuf(int idx) {
    model->Del(idx);
}

void TimeLine::add_aaudioBuf(const QString &src, long long medStart, long long medEnd) {
    aModel->add_buf(src, medStart, medEnd);
}

void TimeLine::rem_aaudioBuf(int idx) {
    aModel->rem_buf(idx);
}

void TimeLine::set_aaudio_sPosRatio(int idx, double val) {
    aModel->set_sPosRatio(idx, val);
}

void TimeLine::add_blur(long long vTime, int x, int y, int w, int h) {
    model->add_blur(vTime, x, y, w, h);
}

void TimeLine::set_hasAudio(int idx) {
    model->set_hasAudio(idx);
}

void TimeLine::save(const QString &path) {
    std::ofstream out(path.toUtf8().constData());
    //out << get_totalVidLen();
    out << model->getModelVec()->size() << " " << aModel->getModelVec()->size() << " ";
    for (auto val : *model->getModelVec()) {
        val.save(out);
    }
    for (auto val : *aModel->getModelVec()) {
        val.save(out);
    }
}

void TimeLine::load(const QString &path) {
    std::ifstream in(path.toUtf8().constData());
    int vidCount, audCount;
    in >> vidCount >> audCount;
    model->force_resetModel(vidCount);
    for (auto val : *model->getModelVec()) {
        val.load(in);
    }
    model->emit_everythingChanged();
    //
    aModel->force_resetModel(audCount);
    for (auto val : *aModel->getModelVec()) {
        val.load(in);
    }
    aModel->emit_everythingChanged();
}

void TimeLine::trim(ll minLen) {
    model->trim(minLen);
}

void TimeLine::trim_aaudio(ll minLen) {
    aModel->trim(minLen);
}

void TimeLine::cut_interval(ll start, ll end) {
    model->cut_interval(start, end);
}




