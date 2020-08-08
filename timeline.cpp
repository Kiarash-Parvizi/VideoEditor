#include "timeline.h"
#include<QtDebug>

TimeLine::TimeLine(TVideo_Model* model, QObject* parent)
    : QObject(parent)
    , model(model)
{
    connect(model, &TVideo_Model::changed_totalTime, this, &TimeLine::slot_totalVidLen);
}

ull TimeLine::get_totalVidLen() {
    return model->get_totalTime();
}

void TimeLine::slot_totalVidLen() {
    qDebug() << "totalVidLen changed";
    emit changed_totalVidLen();
}

QAbstractListModel* TimeLine::get_model() {
    return model;
}

ull TimeLine::calc_width(ull len, ull winWidth) {
    qDebug() << "calc_width";
    return winWidth * ((double)len/(double)get_totalVidLen());
}

void TimeLine::ins_Buf(const QString& source, ull start, ull end, ull vTime) {
    model->Insert({source, end-start, start, end}, vTime);
}

void TimeLine::del_VBuf(int idx) {
    model->Del(idx);
}




