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

void TimeLine::set_aaudio_sPosRatio(int idx, double val) {
    aModel->set_sPosRatio(idx, val);
}

void TimeLine::trim(long long minLen) {
    model->trim(minLen);
}

void TimeLine::cut_interval(ll start, ll end) {
    model->cut_interval(start, end);
}




