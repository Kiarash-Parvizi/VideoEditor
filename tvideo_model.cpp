#include "tvideo_model.h"
#include <QModelIndex>
#include<QDebug>

TVideo_Model::TVideo_Model(QObject *parent) :
    QAbstractListModel(parent) {
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

void TVideo_Model::set_totalTime(ull v) {
    totalTime = v;
    emit changed_totalTime();
}

void TVideo_Model::inc_totalTime(ull v) {
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

void TVideo_Model::Insert(const TVideo_Model::ModelItem& item, ull vTime) {
    // begin
    beginInsertRows(QModelIndex(),0,0);
    //
    v.insert(0, item);
    inc_totalTime(item.len);
    // end
    endInsertRows();
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
