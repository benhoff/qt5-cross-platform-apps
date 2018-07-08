#ifndef FOOD_H
#define FOOD_H

#include <QObject>
#include <QRandomGenerator>
#include <QPoint>
#include <QRect>
#include <QColor>


class Food : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x)
    Q_PROPERTY(int y READ y)
    Q_PROPERTY(int radius READ radius)
    Q_PROPERTY(bool enabled READ enabled)
    Q_PROPERTY(QColor hue READ hue)
public:
    explicit Food(QRect *game_size, QObject *parent = nullptr);
    static constexpr qreal _mass = 78.54;
    static constexpr qreal _radius = 5.0;

    void generate();

    int x();
    int y();
    qreal radius();
    qreal mass();
    QColor hue();
    bool enabled();
    void set_enabled(bool value);
    // FIXME: Figure out if this is needed
    bool is_disabled();


private:
    QPoint _position;
    QColor _hue;
    bool _enabled;
    QRect *_game_size;
};

#endif // FOOD_H
