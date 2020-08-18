#ifndef BLUR_H
#define BLUR_H

#include<effect.h>

class Blur : public Effect {
public:
    Blur(int x, int y, int w, int h);
    ~Blur();
    const QString& get_command() override;
    void calc_command(int i1, int i2);
private:
    int x, y, w, h;
};

#endif // BLUR_H
