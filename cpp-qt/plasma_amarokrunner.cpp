/*
 *   Copyright (C) 2008 Bruno Virlet <bvirlet@kdemail.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License version 2 as
 *   published by the Free Software Foundation
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include "amarokrunner.h"

#include <QDBusInterface>
#include <QDBusReply>
#include <QDBusMetaType>
#include <QStringList>
#include <QVector>

#include <KDebug>
#include <KMimeType>
#include <KRun>
#include <KUrl>
#include <KIcon>

Q_DECLARE_METATYPE(QList<QList<QVariant> >)
static int typeId = qDBusRegisterMetaType<QList<QList<QVariant> > >();

AmarokRunner::AmarokRunner(QObject *parent, const QVariantList& args)
    : Plasma::AbstractRunner(parent, args)
{
    KGlobal::locale()->insertCatalog("krunner_amarok");
    Q_UNUSED(args);

    setObjectName(i18n("Amarok Runner"));
    setSpeed(AbstractRunner::SlowSpeed);
}

AmarokRunner::~AmarokRunner()
{
}

void AmarokRunner::match(Plasma::RunnerContext &context)
{
    if ( context.query().length() < 3 ) return;

    QDBusInterface amarok("org.kde.amarok",
                         "/Collection", "org.kde.Amarok.Collection" );

    QString query( "SELECT r.name, t.title, u.rpath, l.name FROM urls as u, tracks as t, artists as r, albums as l WHERE t.album = l.id AND t.artist = r.id AND u.id = t.url" );
    QStringList queryItems = context.query().split( " ", QString::SkipEmptyParts );
    foreach( QString queryItem, queryItems ) {
      query.append( QString(" AND (t.title LIKE '%%%1%%'").arg( queryItem ) );
      query.append( QString(" OR r.name LIKE '%%%1%%')").arg( queryItem ) );
    }
    query.append( " ORDER BY l.name, t.title LIMIT 20" );

    QDBusReply<QStringList> reply = amarok.call( "query", query );
					       
    if (!reply.isValid()) return;

    QList<Plasma::QueryMatch> matches;

    QListIterator<QString> it( reply );

    while( it.hasNext() ) {
      QString artist( it.next() );
      QString title( it.next() );
      QString url( it.next() );
      QString album( it.next() );

      Plasma::QueryMatch match( this );
      match.setType( Plasma::QueryMatch::ExactMatch );
      match.setIcon(KIcon("amarok"));
      match.setText( title );
      match.setData( url );
      matches.append( match );
    }
    context.addMatches( context.query(), matches );
}

void AmarokRunner::run(const Plasma::RunnerContext &context, const Plasma::QueryMatch &match)
{
    Q_UNUSED(context)
    QMutexLocker lock(bigLock());
    

    QDBusInterface amarok( "org.kde.amarok",
                         "/Playlist", "org.kde.Amarok.Player" );

    amarok.call( "playMedia", match.data().toString() );
}

#include "amarokrunner.moc"
