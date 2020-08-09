#include "tvideo_model.h"
#include <QModelIndex>
#include<QDebug>

TVideo_Model::TVideo_Model(QObject *parent)
    : QAbstractListModel(parent)
{
    CreateDefaultModel();
}

void TVideo_Model::CreateDefaultModel()
{
    Add({"John.The grates sdf Something cool", 600000, 100, 200});
    Add({"John.The grates sdf Something cool", 800000, 100, 200});
    Add({"Vid12", 1200000, 100, 200});
    Add({"Gholam", 5000000, 100, 200});
    //Add({"Gholam", 5000000, 100, 200});
}

void TVideo_Model::set_totalTime(ll v) {
    totalTime = v;
    emit changed_totalTime();
}

void TVideo_Model::inc_totalTime(ll v) {
    totalTime += v;
    emit changed_totalTime();
}

void TVideo_Model::Add(const TVideo_Model::ModelItem& item) {
    // begin
    beginInsertRows(QModelIndex(),v.size(),v.size());
    //
    v.push_back(item);
    inc_totalTime(item.len);
    // end
    endInsertRows();
}

void TVideo_Model::Insert(const TVideo_Model::ModelItem & item, int loc) {
    // begin
    beginInsertRows(QModelIndex(),loc,loc);
    //
    v.insert(loc, item);
    inc_totalTime(item.len);
    // end
    endInsertRows();
}

void TVideo_Model::Insert_Buf(const TVideo_Model::ModelItem& item, ll vTime) {
    // begin
    beginInsertRows(QModelIndex(),0,0);
    //
    v.insert(0, item);
    inc_totalTime(item.len);
    // end
    endInsertRows();
}

void TVideo_Model::Rem_inclusive(int s, int e) {
    beginRemoveRows(QModelIndex(), s, e);
    for (int a = s; a <= e; a++) {
        inc_totalTime(-v[a].len);
    }
    v.erase(v.begin()+s, v.begin()+e+1);
    endRemoveRows();
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

void TVideo_Model::set_emitStateChanged_func(const std::function<void ()>& func) {
    emitStateChanged = func;
}

void TVideo_Model::cut_interval(ll start, ll end)
{
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
                inc_totalTime(-len+start_offset);
                v[i].set_end(v[i].start + start_offset);
                auto obj = v[i]; obj.set_start(obj.end - end_offset);
                Insert(obj, i+1);
            } else {
                inc_totalTime(-len+start_offset);
                v[i].set_end(v[i].start + start_offset);
                //
                inc_totalTime(-v[j].len+end_offset);
                v[j].set_start(v[j].end - end_offset);
                qDebug() << "2>>";
                //
                if (j-i > 1) {
                    qDebug() << ">" << i << ", " << j << '\n';
                    Rem_inclusive(i+1, j-1);
                }
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
        }

        roles.push_back(Qt::DisplayRole);
        emit dataChanged(createIndex(0,0), createIndex(v.size()-1,0), roles);
    }
}
