#ifndef VPROCESS_H
#define VPROCESS_H

#include <QObject>
#include <timeline.h>

struct vChunk {
    QString vid_src;
    ll vStart, vEnd;
    //
    QString aud_src;
    ll aStart, aEnd;
    //
    QVector<Effect*> effects;
};

class vProcess {
    QMap<QString, int> map_name_id;
public:
    vProcess(const TimeLine* timeline);
};

#endif // VPROCESS_H
