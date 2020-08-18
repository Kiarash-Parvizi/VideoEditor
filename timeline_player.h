#ifndef TIMELINE_PLAYER_H
#define TIMELINE_PLAYER_H

#include <QObject>
#include <QString>
#include <tvideo_model.h>
#include <functional>
#include <QDebug>
#include <QTimer>

#define ll long long

struct Buf {
    QString path; ll startPos, len; int id;
    Buf next(const QVector<TVideo_Model::ModelItem>* v) {
        qDebug() << "next().call";
        qDebug() << "v.size: " << v->size();
        int nId = id+1;
        if (nId < v->size()) {
            auto& obj = (*v)[nId];
            return {obj._source, obj.start, obj.len, nId};
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
    Q_INVOKABLE void change_process();

signals:
    void playBuffer(const QString& path, int startPos, bool isRoot, const QString& extra_path, int extra_startPos);

// private funcs
private:
    Buf get_requested_buf(ll vTime);
    void Rec(Buf buf, ll idx, ll wait);

private:
    const QVector<TVideo_Model::ModelItem>* v;
    TVideo_Model& model;
    ll processIdx = 0;
};

#endif // TIMELINE_PLAYER_H
