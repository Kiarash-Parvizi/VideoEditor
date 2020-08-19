#ifndef BLUR_H
#define BLUR_H

#include<QtDebug>
#include<effect.h>

class Blur : public Effect {
public:
    Blur();
    Blur(int x, int y, int w, int h);
    ~Blur();
    virtual const QString& get_command(int i1, int i2) override;
    virtual Effect* clone() override;
    virtual void read_data(std::ifstream& in) override;
    virtual void write_data(std::ofstream& out) override;
private:
    int x, y, w, h;
};

#endif // BLUR_H
