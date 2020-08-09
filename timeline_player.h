#ifndef TIMELINE_PLAYER_H
#define TIMELINE_PLAYER_H

#include <QObject>
#include <QString>
#include <tvideo_model.h>
#include <functional>
#include <QTimer>

#define ll long long

struct Buf {
    QString path; ll startPos, len; int id;
    Buf next(const QVector<ModelItem>* v) {
        if (id < v->size()) {
            auto& obj = (*v)[id];
            return {obj._source, obj.start, obj.len, id+1};
        } else {
            return {"Err", -1, -1, -1};
        }
    }
};

class TimeLine_Player : public QObject {
    Q_OBJECT

public:
    explicit TimeLine_Player(TVideo_Model& model, QObject *parent = nullptr);

    Q_INVOKABLE void play_pos(ll vTime);

signals:
    void playBuffer(const QString& path, int startPos, bool isRoot, const QString& extra_path, int extra_startPos);

// private funcs
private:
    Buf get_requested_buf(ll vTime);

private:
    const QVector<ModelItem>* v;
    TVideo_Model& model;
    ll processIdx = 0;
};

#endif // TIMELINE_PLAYER_H
