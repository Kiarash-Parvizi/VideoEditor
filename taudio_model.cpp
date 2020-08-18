#include "taudio_model.h"


void TAudio_Model::set_sPosRatio(int idx, double val) {
    v[idx].sPosRatio = val;
    emit dataChanged(createIndex(idx,0), createIndex(idx,0), {sPosRatio});
}

void TAudio_Model::add_buf(const QString& src, long long medStart, long long medEnd) {
    auto item = TAudio_Model::ModelItem(src, medStart, medEnd);
    item.set_sPosRatio(calcPlace(item.len));
    if (item.sPosRatio == -1) return;
    Add(item);
}

void TAudio_Model::rem_buf(int idx) {
    // begin
    beginRemoveRows(QModelIndex(),idx,idx);
    //
    inc_totLen(-v[idx].len);
    v.remove(idx);
    // end
    endRemoveRows();
}

void TAudio_Model::trim(ll minLen) {
    for (int i = 0; i < v.size(); ) {
        if (v[i].len < minLen) {
            rem_buf(i);
        } else {
            i++;
        }
    }
}

TAudio_Model::TAudio_Model(QObject *parent)
    : QAbstractListModel(parent)
{
}

int TAudio_Model::rowCount(const QModelIndex&) const {
    return v.size();
}

QVariant TAudio_Model::data(const QModelIndex &index, int role) const {
    int i = index.row();
    if (i < 0 || i >= v.size()) {
        return QVariant();
    }

    if (role == _source) {
        return v[i]._source;
    } if (role==len) {
        return v[i].len;
    } if (role==medStart) {
        return v[i].medStart;
    } if (role==medEnd) {
        return v[i].medEnd;
    } if (role==sPosRatio) {
        return v[i].sPosRatio;
    }
    if (role==Qt::DisplayRole) {
        return v[i]._source + " ("+ QString::number(v[i].len) +")";
    }
    return QVariant();
}

QHash<int, QByteArray> TAudio_Model::roleNames() const {
    QHash<int, QByteArray> r =QAbstractListModel::roleNames();
    r[_source]="_source";
    r[len]="len";
    r[medStart]="medStart";
    r[medEnd]="medEnd";
    r[sPosRatio]="sPosRatio";
    return r;
}

void TAudio_Model::setItemData2(int index, QVariant value, const QString& role) {
    if (index >=0 && index <= v.size()) {
        qDebug() << "setItemData";
        QVector<int> roles;

        if(role=="_source") {
            v[index]._source = value.toString();
            roles.push_back(_source);
        } else if (role=="len") {
            v[index].len = value.toInt();
            roles.push_back(len);
        } else if (role=="medStart") {
            roles.push_back(medStart);
        } else if (role=="medEnd") {
            roles.push_back(medEnd);
        } else if (role=="sPosRatio") {
            roles.push_back(sPosRatio);
        }

        roles.push_back(Qt::DisplayRole);
        emit dataChanged(createIndex(0,0), createIndex(v.size()-1,0), roles);
    }

}

void TAudio_Model::set_totalVideoLen(long long v) {
    auto pre = totVideoLen;
    // asn
    totVideoLen = v;
    //
    if (totVideoLen < pre) {
        checkPlace();
    }
}

void TAudio_Model::rearrange() {
    qDebug() << "reARRANGE";
    double cp = 0; int i = 0;
    for (auto& el : v) {
        double lenR = (double)el.len/(double)totVideoLen;
        //
        el.sPosRatio = cp;
        //
        i++; cp += lenR;
    }
    emit dataChanged(createIndex(0,0), createIndex(v.size()-1,0), {sPosRatio});
}

bool TAudio_Model::placedOk() {
    for (int i = 0; i < v.size(); i++) {
        const auto& item = v[i];
        double rx1   = item.sPosRatio;
        double rx1_p = rx1 + (double)item.len/(double)totVideoLen;
        if (rx1 < 0 || rx1 > 1 || rx1_p > 1) {
            return false;
        }
        // check agains all others
        for (int j = i+1; j < v.size(); j++) {
            const auto& item2 = v[j];
            double rx2   = item2.sPosRatio;
            double rx2_p = rx2 + (double)item2.len/(double)totVideoLen;
            if (	(rx2 > rx1 && rx2 < rx1_p)
                ||	(rx2_p > rx1 && rx2_p < rx1_p)
                ||	(rx2_p >= rx1_p && rx2 <= rx1)
            ){
                qDebug() << "(" << rx1 << ", " << rx1_p << ") . (" << rx2 << ", " << rx2_p << ")";
                return false;
            }
        }
    }
    return true;
}

void TAudio_Model::checkPlace() {
    qDebug() << "totLen: " << totLen << " | vidLen" << totVideoLen;
    while(totLen > totVideoLen) {
        if (!v.size()) return;
        rem_buf(0);
    }
    if (!placedOk()) {
        rearrange();
    }
}

double TAudio_Model::calcPlace(long long len) {
    if (len > totVideoLen) return -1;
    if (v.size() == 0) {
        return 0;
    }
    double lenR = (double)len/(double)totVideoLen;
    double rx1, rx1_p;
    for (int i = 0; i < v.size(); i++) {
        for (int a = 0; a < 2; a++) {
            const auto& item = v[i];
            double rx   = item.sPosRatio;
            double rx_p = rx + (double)item.len/(double)totVideoLen;
            if (a) {
                rx1_p= rx - 0.004;
                rx1  = rx1_p - lenR;
            } else {
                rx1  = rx_p + 0.004;
                rx1_p= rx1 + lenR;
            }
            if (rx1 < 0 || rx1 > 1 || rx1_p > 1) {
                continue;
            }
            // is-Interval-Empty
            int j = 0;
            for (; j < v.size(); j++) {
                if (i == j) continue;
                const auto& item2 = v[j];
                double rx2   = item2.sPosRatio;
                double rx2_p = rx2 + (double)item2.len/(double)totVideoLen;
                qDebug() << "(" << rx1 << ", " << rx1_p << ") . (" << rx2 << ", " << rx2_p << ")";
                if (	(rx2 > rx1 && rx2 < rx1_p)
                    ||	(rx2_p > rx1 && rx2_p < rx1_p)
                    ||	(rx2_p >= rx1_p && rx2 <= rx1)
                ){
                    break;
                }
            }
            if (j == v.size()) {
                return rx1;
            }
        }
    }
    return -1;
}

void TAudio_Model::Add(const TAudio_Model::ModelItem& item) {
    if (item.len <= 0) return;
    // begin
    beginInsertRows(QModelIndex(),v.size(),v.size());
    //
    v.push_back(item);
    inc_totLen(item.len);
    // end
    endInsertRows();
}

void TAudio_Model::inc_totLen(ll amount) {
    totLen += amount;
}
