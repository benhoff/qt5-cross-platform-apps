#ifndef GAMEINTERFACE_H
#define GAMEINTERFACE_H

#include <QObject>
#include <QTimer>
#include <QVariant>

class Player;
class Food;
class Virus;


class GameInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList food READ food NOTIFY food_changed)
    Q_PROPERTY(QVariantList players READ players NOTIFY players_changed)
    Q_PROPERTY(QVariantList viruses READ viruses NOTIFY viruses_changed)

public:
    explicit GameInterface(QObject *parent = nullptr);
    QVariantList food();
    QVariantList viruses();
    QVariantList players();
    void track_food_fired_by_players(Food *new_food);
    void track_new_virus(Virus *virus);
    void remove_virus_from_game(Virus *virus);
    QRect *game_size();
    void start_game();
    void add_player(Player* player);

    void set_game_size(int width, int height);
    Q_INVOKABLE Player* get_player(QString authentication);

public slots:
    void increment_game_step();
    void remove_player(Player *player);
    void _check_virus_interactions(Food* food);
    void _check_player_interactions(Food* food);

protected:
    void create_game_objects();
    void create_viruses(int number=5);
    void create_food(int number=500);
    void check_game_object_interactions();

signals:
    void food_changed();
    void viruses_changed();
    void players_changed();

private:
    QVariantList _food;
    QVariantList _viruses;
    QVariantList _players;
    QRect *_game_size;
    QTimer _game_interval;
};

#endif // GAMEINTERFACE_H
