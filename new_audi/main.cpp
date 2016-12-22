#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QFileSystemModel>
#include <QSortFilterProxyModel>
#include <QMimeDatabase>

class DisplayFileSystemModel : public QFileSystemModel {
    Q_OBJECT
public:
    explicit DisplayFileSystemModel(QObject *parent = Q_NULLPTR)
        : QFileSystemModel(parent) {}

    enum Roles  {
        UrlStringRole = Qt::UserRole + 4
    };
    Q_ENUM(Roles)

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const Q_DECL_OVERRIDE
    {
        if (index.isValid()) {
            switch (role) {

            case UrlStringRole:
                return QVariant(QUrl::fromLocalFile(filePath(index)).toString());
            default:
                break;
            }
        }
        return QFileSystemModel::data(index, role);
    }

    QHash<int,QByteArray> roleNames() const Q_DECL_OVERRIDE
    {
        QHash<int, QByteArray> result = QFileSystemModel::roleNames();
        return result;
    }

    Q_INVOKABLE QItemSelection selection(const QModelIndex &from, const QModelIndex &to) {
        return  QItemSelection(from,to);
    }
};

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QFileSystemModel *fsm = new DisplayFileSystemModel(&engine);
    fsm->setRootPath(QDir::homePath());
    fsm->setResolveSymlinks(true);

    //QSortFilterProxyModel *sfpm = new QFileSystemModel();
    //fsm->setModel(sfpm);

    QMimeDatabase db;
    QList<QMimeType> MimeFilter = db.allMimeTypes();
    QStringList AudioFilter;

    foreach(QMimeType mime, MimeFilter){
        if(mime.name().startsWith("audio/")){
            AudioFilter << mime.suffixes();
        }
    }
    for(int i = 0; i < AudioFilter.count(); i++) {
        AudioFilter[i] = "*." + AudioFilter[i];
    }

    fsm->setNameFilters(AudioFilter);
    fsm->setNameFilterDisables(false); // no files that don't pass the name filter


    engine.rootContext()->setContextProperty("fileSystemModel", fsm);
    engine.rootContext()->setContextProperty("rootPathIndex", fsm->index(fsm->rootPath()));

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

#include "main.moc"
