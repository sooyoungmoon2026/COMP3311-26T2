create table Car (
    regoNo  char(6) primary key,
    model   text,
    year    integer
);

create table Person (
    licenceNo   integer primary key,
    name        text,
    address     text
);

create table Accident (
    reportNo            integer primary key,
    location            text,
    accidentDate        date
);

create table Owns(
    car     char(6),
    person  integer references Person(licenceNo),

    primary key (car, person),
    foreign key (car) references Car(regoNo)
);

create table Involved (
    car         char(6) references Car(regoNo),
    person       integer references Person(licenceNo),
    accident    integer references Accident(reportNo),

    primary key (car,person, accident)
);