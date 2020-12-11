
enum SessionStatus{SCHEDULED,LIVE,COMPLETED,DELAYED}
enum SessionType{STUDY,REVISION}

class Subject{

  Subject({this.subjectId,this.name,this.topics,this.emoji});

  String subjectId,name;
  List<Topic> topics;
  String emoji;

  factory Subject.idMapToObj(String id,Map m){
    Subject s =  new Subject(
      subjectId: id,
      name: m['name'],
      emoji: m['emoji'],
    );
    List<Topic> ts = new List<Topic>();
    Map tsmap = m['topics'];
    tsmap?.forEach((tid,tdata){
      ts.add(new Topic.idMapToObj(tid, tdata));
    });
    s.topics = ts;
    return s;
  }

}

class Topic{

  Topic({
    this.topicId, this.subjectId, this.confidenceLevel, this.firstAdded, this.latestRevisionNumber, this.name, this.sessions, this.studied,this.mastery
  });

  String topicId, name, subjectId;
  bool studied;
  DateTime firstAdded;
  int latestRevisionNumber;
  int confidenceLevel;
  List sessions;
  double mastery; //0-10

    factory Topic.idMapToObj(String id,Map m){
    Topic t = new Topic(
      topicId: id,
      name: m['name'],
      subjectId: m['subjectId'],
      confidenceLevel: m['confidenceLevel'],
      mastery: double.parse(m['mastery'].toString()),
      latestRevisionNumber: m['latestRevisionNumber']
    );
    List ss = new List();
    if(m['sessions']!=null){
      ss = m['sessions'];
      t.sessions = ss;
    }
    return t;
  }

}

class Session{

  Session({this.sessionId,this.topicId,this.revisionNumber,this.scheduledTime,this.sessionStatus,this.sessionType,this.eFactor,this.confidenceLevel,this.subjectId,this.prevSessionId,this.nextSessionId,this.lastSchedule});

  String sessionId, topicId, prevSessionId, nextSessionId, subjectId;
  int revisionNumber; // expectedPomodoros, registeredPomodoros; //??
  DateTime scheduledTime, lastSchedule;
  SessionStatus sessionStatus;
  SessionType sessionType;
  double fudgeRatio;
  Map<int,DateTime> timeline;
  double eFactor;
  int confidenceLevel;

  factory Session.idMapToObj(String id,Map m){
    return new Session(
      sessionId: id,
      topicId: m["topicId"],
      revisionNumber: m['revisionNumber'],
      scheduledTime: DateTime.parse(m['scheduledTime']),
      sessionStatus: m['sessionStatus']==SessionStatus.LIVE.toString()?SessionStatus.LIVE:m['sessionStatus']==SessionStatus.COMPLETED.toString()?SessionStatus.COMPLETED:m['sessionStatus']==SessionStatus.DELAYED.toString()?SessionStatus.DELAYED:SessionStatus.SCHEDULED,
      sessionType: m['sessionType']==SessionType.REVISION?SessionType.REVISION:SessionType.STUDY,
      eFactor: m['eFactor'],
      confidenceLevel: m['confidenceLevel'],
      subjectId: m['subjectId'],
      prevSessionId: m['prevSessionId'],
      nextSessionId: m['nextSessionId'],
      lastSchedule:  m['lastSchedule']!=null?DateTime.parse(m['lastSchedule']):null
    );
  }

}