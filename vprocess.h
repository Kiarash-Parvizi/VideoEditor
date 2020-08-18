#ifndef VPROCESS_H
#define VPROCESS_H

#include <QObject>
#include <timeline.h>

struct VChunk {
    int idx;
    // Const
    VChunk();
    VChunk(int idx, const QString& vid_src, ll vStart, ll vEnd, const QString& aud_src, ll aStart, ll aEnd, QVector<Effect*>);
    ~VChunk();
    //-----
    QString vid_src;
    ll vStart, vEnd;
    //
    QString aud_src;
    ll aStart, aEnd;
    //
    QVector<Effect*> effects;
    // funcs
    QString get_command(const QMap<QString, int>& map_name_id) const;
    QString get_finalVOut() const;
    QString get_finalAOut() const;
};

class VProcess : public QObject {
    Q_OBJECT
public:
    VProcess(TimeLine* timeline, QObject* parent = nullptr);

    // call
    Q_INVOKABLE void ExportVideo(const QString& finalFFCommands);
    //

private:
    // reset
    void reset();
    // Register
    QMap<QString, int> map_name_id;
    void register_data(const QString& src);
    // Pack get-vchunks
    QVector<VChunk> vchunks;
    void calc_vchunks_fromVidItems();
    void merge_vchunks_aaudio();
    void calc_vchuncks();
    // ---------------
    // calc ffCommands
    QString gen_init_command();
    QString gen_process_command();
    QString gen_concat_command();
    QString gen_ff_command(const QString& finalFFCommand);
    // ---------------
private:
    TimeLine* timeline;
    QString ffCommand = "ffmpeg -y ";
    QString input_files = "";
};

#endif // VPROCESS_H
