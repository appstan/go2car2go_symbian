#include "engine.h"
#include "json.h"

// QtMobility API headers
#include <QtNetwork>
#include <qmobilityglobal.h>
#include <qnetworkconfigmanager.h>
#include <qnetworksession.h>

#include <QNetworkAccessManager>
#include <QNetworkProxyFactory>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkDiskCache>
#include <QDateTime>
#include <QGeoCoordinate>
#include <math.h>

using namespace QtJson;


const QByteArray GO2CAR2GO_ConsumerKey    = "TemirlanTentimishov";
const QByteArray GO2CAR2GO_ConsumerSecret = "QPCvPebF5P11mWX9";

const QByteArray GO2CAR2GO_HOST = "http://www.car2go.com/api/v2.1/";
const QByteArray GO2CAR2GO_SECURED_HOST = "https://www.car2go.com/api";

const QByteArray CAR2GO_REQUEST_TOKEN_URL = "https://www.car2go.com/api/reqtoken";
const QByteArray CAR2GO_ACCESS_TOKEN_URL  = "https://www.car2go.com/api/accesstoken";
const QByteArray CAR2GO_AUTHORIZE_TOKEN_URL = "https://www.car2go.com/api/authorize";
const QString CAR2GO_REQUEST_CALLBACK_URL = "foo";

Go2Car2GoEngine::Go2Car2GoEngine()
{

    net_manager = new QNetworkAccessManager ( this );
    connect ( net_manager, SIGNAL ( finished ( QNetworkReply* ) ),
              this, SLOT ( replyFinished ( QNetworkReply* ) ) );

    QTimer::singleShot(0, this, SLOT(delayedInit()));

}

Go2Car2GoEngine::~Go2Car2GoEngine()
{
    delete net_manager;
    net_session->close();
}

int Go2Car2GoEngine::get ( const Car2goMethod &method )
{
    request ( method, true );
}

int Go2Car2GoEngine::post ( const Car2goMethod &method )
{
    request ( method, false );
}

int Go2Car2GoEngine::request ( const Car2goMethod &method, bool get )
{
    QMap<QString,QString> map = method.args;

    QMapIterator<QString, QString> i ( map );
    QStringList keyList;
    while ( i.hasNext() )
    {
        i.next();
        keyList << i.key();
    }
    qSort ( keyList.begin(), keyList.end() );

    QUrl url ( GO2CAR2GO_HOST + method.method, QUrl::TolerantMode );
    for ( int i = 0; i < keyList.size(); ++i )
    {
        url.addQueryItem ( keyList.at ( i ),  map.value ( keyList.at ( i ) ) );
    }


    requestCounter++;
    RequestData requestData;
    requestData.requestId = requestCounter;

    QNetworkReply *reply;

    if ( get )
        reply = net_manager->get ( QNetworkRequest ( url ) );
    else
        reply = net_manager->post ( QNetworkRequest ( QUrl(GO2CAR2GO_SECURED_HOST) ), url.encodedQuery () );

    requestDataMap.insert ( reply , requestData );
    qDebug() << "request id: " << url;

    return requestData.requestId;
}

void Go2Car2GoEngine::replyFinished ( QNetworkReply *reply )
{
    QByteArray data = reply->readAll();


    qDebug()<<"*******************************RESPONSE*******************************";
    qDebug() << QString::fromUtf8(data);
    qDebug()<<"**********************************************************************\n\n";

    response.list.clear();
    error.code = 0;
    error.message = "No Errors";

    if ( reply->error() != QNetworkReply::NoError )
    {
        error.code = 1001;
        error.message = reply->errorString ();
    }



    void* userData = requestDataMap.value ( reply ).userData;
    int replyId    = requestDataMap.value ( reply ).requestId;
    bool ok;



    QVariantMap result;

    if (data.isEmpty()){
        error.code = 1001;
        error.message = "Network session error";
    }
    else {
        result = Json::parse(QString::fromUtf8(data), ok).toMap();
        if(!ok) {
            error.code = 3000;
            error.message = QString::fromUtf8(data);
            qDebug() << "An error occurred during parsing";
        }

    }

    emit requestFinished(replyId, result , error );

    requestDataMap.remove ( reply );
    reply->deleteLater();
}

void Go2Car2GoEngine::delayedInit() {
    // Set Internet Access Point
    QNetworkConfigurationManager manager;
    const bool canStartIAP = (manager.capabilities()
                              & QNetworkConfigurationManager::CanStartAndStopInterfaces);
    // Is there default access point, use it
    QNetworkConfiguration cfg = manager.defaultConfiguration();
    if (!cfg.isValid() || (!canStartIAP && cfg.state() != QNetworkConfiguration::Active)) {
        qDebug()<< "network session error";
        return;
    }

    net_session = new QNetworkSession(cfg, this);
    net_session->open();
    net_session->waitForOpened(-1);
}
