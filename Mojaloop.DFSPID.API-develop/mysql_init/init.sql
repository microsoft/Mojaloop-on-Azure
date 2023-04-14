use sqltest

CREATE TABLE participant (
    participantId int NOT NULL,
    LastName varchar(255),
    FirstName varchar(255),
    City varchar(255),
    PRIMARY KEY (participantId)
);

INSERT INTO sqltest.participant (participantId,LastName,FirstName,City) VALUES
	 (1,'test','test','test');