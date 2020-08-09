#include "timeline.h"
#include<cmath>
#include<functional>

TimeLine::TimeLine(TVideo_Model* model, QObject* parent)
    : QObject(parent)
    , model(model)
{
    connect(model, &TVideo_Model::changed_totalTime, this, &TimeLine::slot_totalVidLen);
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

double TimeLine::calc_width(ll len, int winWidth) {
    qDebug() << "calc_width";
    return ((double)winWidth * ((double)len/(double)get_totalVidLen()));
}

void TimeLine::ins_Buf(const QString& source, ll start, ll end, ll vTime) {
    model->Insert_Buf({source, end-start, start, end}, vTime);
}

void TimeLine::del_VBuf(int idx) {
    model->Del(idx);
}

void TimeLine::cut_interval(ll start, ll end) {
    model->cut_interval(start, end);
}




