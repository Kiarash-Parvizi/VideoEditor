#include "timeline_player.h"


void TimeLine_Player::play_pos(long long vTime) {
    auto buffer = get_requested_buf(vTime);
    auto next= buffer.next(v);
    emit playBuffer(buffer.path, buffer.startPos, true, next.path, next.startPos);
    if (next.id == -1) {
        return;
    }
    //std::function<void()> lam;
    Buf buf = next;
    //std::function<void()> lam = [&] {
    //    ll timeTake = buf.len;
    //    buf = buf.next(v);
    //    emit playBuffer(buf.path, buf.startPos, false, "", 0);
    //    if (next.id != -1) {
    //        QTimer::singleShot(timeTake, lam);
    //    }
    //};
    //QTimer::singleShot(buf.len, lam);
}

TimeLine_Player::TimeLine_Player(TVideo_Model &model, QObject *parent)
    : QObject(parent)
    , model(model)
{
    v = model.getModelVec();
}

Buf TimeLine_Player::get_requested_buf(long long vPos) {
    ll vTime = 0;
    for (int i = 0; i < v->size(); i++) {
        auto len = (*v)[i].len;
        auto s = vTime, e = vTime + len;
        // select
        if (vPos >= s && vPos <= e) {
            auto obj = (*v)[i];
            return { obj._source, obj.start+(vPos-vTime), obj.len, i };
        }
        //vTime++
        vTime += len;
    }
    return {"Err", -1, -1, -1};
}
