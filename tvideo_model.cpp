#include "tvideo_model.h"
#include <QModelIndex>
#include<QDebug>

TVideo_Model::TVideo_Model(QObject *parent)
    : QAbstractListModel(parent)
{
}

void TVideo_Model::set_totalTime(ll v) {
    totalTime = v;
    emit changed_totalTime(totalTime);
}

void TVideo_Model::inc_totalTime(ll v) {
    totalTime += v;
    emit changed_totalTime(totalTime);
}

void TVideo_Model::Add(const ModelItem& item) {
    // begin
    beginInsertRows(QModelIndex(),v.size(),v.size());
    //
    v.push_back(item);
    inc_totalTime(item.len);
    // end
    endInsertRows();
}

void TVideo_Model::Insert(const ModelItem & item, int loc) {
    // begin
    beginInsertRows(QModelIndex(),loc,loc);
    //
    v.insert(loc, item);
    inc_totalTime(item.len);
    // end
    endInsertRows();
}

void TVideo_Model::Insert_Buf(const ModelItem& item, ll vTime) {
    // I'll use the vTime later
    // begin
    beginInsertRows(QModelIndex(),v.size(),v.size());
    //
    v.insert(v.end(), item);
    inc_totalTime(item.len);
    // end
    endInsertRows();
}

// returns the total removed time in ms
ll TVideo_Model::Rem_inclusive(int s, int e, bool useIncFunc) {
    beginRemoveRows(QModelIndex(), s, e);
    ll remTime = 0;
    for (int a = s; a <= e; a++) {
        if (useIncFunc)
            inc_totalTime(-v[a].len);
        remTime += v[a].len;
    }
    v.erase(v.begin()+s, v.begin()+e+1);
    endRemoveRows();
    return remTime;
}

void TVideo_Model::Del(int idx) {
    // begin
    beginRemoveRows(QModelIndex(),idx,idx);
    //
    inc_totalTime(-v[idx].len);
    v.remove(idx);
    // end
    endRemoveRows();
}

int TVideo_Model::getIdx(ll vtime)
{
    ll vTime = 0;
    // Find start section
    for (int i = 0; i < v.size(); i++) {
        auto len = v[i].len;
        auto s = vTime, e = vTime + len;
        //
        //qDebug() << "(s,e): " << s << ", " << e;
        //qDebug() << "vtime: " << vtime;
        //qDebug() << "vTime: " << vTime;
        // Find end section:
        if (vtime >= s && vtime <= e) {
            //qDebug() << "id_. ..-> " << i;
            return i;
        }
        //
        vTime += len;
    }
    //qDebug() << "id_. ..-> " << -1;
    return -1;
}

void TVideo_Model::trim(ll minLen) {
    for (int i = 0; i < v.size(); ) {
        if (v[i].len < minLen) {
            Del(i);
        } else {
            i++;
        }
    }
}

void TVideo_Model::add_blur(ll vTime, int x, int y, int w, int h) {
    int idx = getIdx(vTime);
    if (idx == -1) {
        qDebug() << "Error: Invalid properties";
    }
    v[idx].effects.push_back(new Blur(x, y, w, h));
}

void TVideo_Model::set_hasAudio(int idx) {
    v[idx].hasAudio = !v[idx].hasAudio;
}

void TVideo_Model::set_emitStateChanged_func(const std::function<void ()>& func) {
    emitStateChanged = func;
}

void TVideo_Model::cut_interval(ll start, ll end)
{
    if (start == end) return;
    qDebug() << "start: " << start;
    qDebug() << "end: " << end;
    ll vTime = 0;
    ll start_offset = -1, end_offset = -1;
    bool op_ok = false;
    // Find start section
    int i, j;
    for (i = 0; i < v.size(); i++) {
        auto len = v[i].len;
        auto s = vTime, e = vTime + len;
        //
        // Find end section:
        if (start >= s && start <= e) {
            for (j = i; j < v.size(); j++) {
                auto len = v[j].len;
                auto s = vTime, e = vTime + len;
                if (end >= s && end <= e) {
                    end_offset = e - end;
                    op_ok = true;
                    break;
                }
                //vTime++
                vTime += len;
            }
            start_offset = start - s;
            // Modify
            if (!op_ok || (i == j && start_offset + end_offset == len)) {
                return;
            }
            qDebug() << "make the cut";
            qDebug() << "I: " << i;
            qDebug() << "J: " << j;
            if (i == j) {
                qDebug() << "1>>";
                auto obj = v[i]; obj.set_start(obj.end - end_offset);
                Insert(obj, i+1);
                v[i].set_end(v[i].start + start_offset);
                // inc totalTime
                inc_totalTime(-len+start_offset);
            } else {
                ll remT1 = -len+start_offset;
                v[i].set_end(v[i].start + start_offset);
                //
                ll remT2 = -v[j].len+end_offset;
                v[j].set_start(v[j].end - end_offset);
                qDebug() << "2>>";
                //
                ll remT_series = 0;
                if (j-i > 1) {
                    qDebug() << ">" << i << ", " << j << '\n';
                    remT_series = Rem_inclusive(i+1, j-1, false);
                }
                // inc totalTime
                inc_totalTime(remT1+remT2-remT_series);
            }
            emitStateChanged();
            // ------
            break;
        }
        //vTime++
        vTime += len;
    }
}

int TVideo_Model::rowCount(const QModelIndex&) const {
    return v.size();
}

QVariant TVideo_Model::data(const QModelIndex &index, int role) const {
    int i = index.row();
    if (i < 0 || i >= v.size()) {
        return QVariant();
    }

    if (role == _source) {
        return v[i]._source;
    } if (role==len) {
        return v[i].len;
    } if (role==start) {
        return v[i].start;
    } if (role==end) {
        return v[i].end;
    } if (role==hasAudio) {
        return v[i].hasAudio;
    }
    if (role==Qt::DisplayRole) {
        return v[i]._source + " ("+ QString::number(v[i].len) +")";
    }
    return QVariant();
}

QHash<int, QByteArray> TVideo_Model::roleNames() const {
    QHash<int, QByteArray> r =QAbstractListModel::roleNames();
    r[_source]="_source";
    r[len]="len";
    r[start]="start";
    r[end]="end";
    r[hasAudio]="hasAudio";
    return r;
}

int TVideo_Model::get_totalTime() {
    return totalTime;
}

void TVideo_Model::setItemData2(int index, QVariant value, QString role) {
    if (index >=0 && index <= v.size()) {
        QVector<int> roles;

        if(role=="_source") {
            v[index]._source = value.toString();
            roles.push_back(_source);
        } else if (role=="len") {
            v[index].len = value.toInt();
            roles.push_back(len);
        } else if (role=="start") {
            roles.push_back(start);
        } else if (role=="end") {
            roles.push_back(end);
        } else if (role=="hasAudio") {
            roles.push_back(hasAudio);
        }

        roles.push_back(Qt::DisplayRole);
        emit dataChanged(createIndex(0,0), createIndex(v.size()-1,0), roles);
    }
}
