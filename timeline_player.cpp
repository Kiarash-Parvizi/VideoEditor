#include "timeline_player.h"

//#include<util.h>
#include<thread>
#include<chrono>

void TimeLine_Player::Rec(Buf buf, ll exId, ll wait) {
    if (exId != this->processIdx) return;
    qDebug() << "Rec";
    std::this_thread::sleep_for(std::chrono::milliseconds(wait));
    qDebug() << "id: " << exId << " | valid: " << this->processIdx;
    //
    qDebug() << "do now";
    emit playBuffer(buf.path, buf.startPos, false, "", 0);
    //
    auto next = buf.next(this->v);
    if (next.id != -1) {
        std::thread(&TimeLine_Player::Rec, this, next, exId, buf.len).detach();
    }
    qDebug() << "done now";
}

void TimeLine_Player::play_pos(long long vTime) {
    auto buffer = get_requested_buf(vTime);
    auto next= buffer.next(v);
    emit playBuffer(buffer.path, buffer.startPos, true, next.path, next.startPos);
    if (next.id == -1) {
        return;
    }
    processIdx++;
    //std::function<void()> lam;
    //std::function<void(Buf)> lam = [&](Buf buf) {
    //};
    std::thread(&TimeLine_Player::Rec, this, next, processIdx, buffer.len).detach();
    //invoke(lam, buffer.len-buffer.startPos, processIdx, &processIdx, next);
}

TimeLine_Player::TimeLine_Player(TVideo_Model &model, QObject *parent)
    : QObject(parent)
    , model(model)
{
    v = model.getModelVec();
}

Buf TimeLine_Player::get_requested_buf(long long vPos) {
    ll vTime = 0;
    qDebug() << "get_buffer: " << v->size();
    for (int i = 0; i < v->size(); i++) {
        auto len = (*v)[i].len;
        auto s = vTime, e = vTime + len;
        // select
        if (vPos >= s && vPos <= e) {
            qDebug() << "select: " << i;
            auto obj = (*v)[i];
            qDebug() << "len: " << vPos-vTime << " | obj.len: " << obj.len;
            return { obj._source, obj.start+(vPos-vTime), obj.len-(vPos-vTime), i };
        }
        //vTime++
        vTime += len;
    }
    return {"Err", -1, -1, -1};
}
