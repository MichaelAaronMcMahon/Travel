Create database travelregistration;
Create table CustomerRep(
	Username VARCHAR(100) PRIMARY KEY,
    Password VARCHAR(100)
);

CREATE TABLE Airport(
	AirportID CHAR(3) PRIMARY KEY,
    AirportName varchar(100) 
);

CREATE TABLE Airline (
    AirlineID CHAR(2) PRIMARY KEY,
    AirlineName varchar(100)
);

CREATE TABLE Customer (
    CustomerName VARCHAR(125),
    Username VARCHAR(100) PRIMARY KEY,
    Password VARCHAR(100)
);

CREATE TABLE Aircraft (
    Seats INT,
    AirlineID CHAR(2),
    AircraftName varchar(100),
    PRIMARY KEY (Seats , AirlineID),
    FOREIGN KEY (AirlineID)
        REFERENCES Airline (AirlineID)
);

CREATE TABLE Flight (
    OperationDays VARCHAR(100),
    DomesticOrInternational VARCHAR(13),
    Seats INT,
    AirlineID CHAR(2),
    FlightNumber INT,
    DepartureAirportID VARCHAR(100),
    DestinationAirportID VARCHAR(100),
    DepartureTime TIMESTAMP,
    ArrivalTime TIMESTAMP,
    PRIMARY KEY (FlightNumber , Seats , AirlineID),
    FOREIGN KEY (DepartureAirportID) references Airport(AirportID),
    FOREIGN KEY (DestinationAirportID) references Airport(AirportID),
    FOREIGN KEY (Seats , AirlineID)
        REFERENCES Aircraft (Seats , AirlineID)
);

CREATE TABLE Ticket (
    TicketNumber INT PRIMARY KEY,
    SeatNumber VARCHAR(5),
    class VARCHAR(9),
    TotalFare FLOAT,
    BookingFee FLOAT,
    RoundTripOrOneWay varchar(25),
    RemainingSeats int
);

CREATE TABLE FlightsForTicket (
    TicketNumber INT,
    Seats INT,
    AirlineID CHAR(2),
    FlightNumber INT,
    PRIMARY KEY (TicketNumber , Seats , AirlineID , FlightNumber),
    FOREIGN KEY (TicketNumber)
        REFERENCES Ticket (TicketNumber),
    FOREIGN KEY (Seats , AirlineID , FlightNumber)
        REFERENCES flight (Seats , AirlineID , FlightNumber)
);

CREATE TABLE TicketHistory (
    TicketNumber INT,
    Username VARCHAR(100),
    PRIMARY KEY (TicketNumber , Username),
    FOREIGN KEY (TicketNumber)
        REFERENCES ticket (TicketNumber),
    FOREIGN KEY (Username)
        REFERENCES customer (Username)
);

CREATE TABLE CustomersForTicket (
    Username VARCHAR(100),
    TicketNumber INT,
    PRIMARY KEY (Username , TicketNumber),
    FOREIGN KEY (Username)
        REFERENCES customer (Username) on delete cascade,
    FOREIGN KEY (TicketNumber)
        REFERENCES ticket (TicketNumber) on delete cascade
);

CREATE TABLE WaitingListForTicket (
    Username VARCHAR(100),
    TicketNumber INT,
    PRIMARY KEY (Username , TicketNumber),
    FOREIGN KEY (Username)
        REFERENCES customer (Username),
    FOREIGN KEY (TicketNumber)
        REFERENCES ticket (TicketNumber)
);

CREATE TABLE Admin (
    Username VARCHAR(100) PRIMARY KEY,
    Password VARCHAR(100)
);

Create table QuestionsAndAnswers(
	Username VARCHAR(100) PRIMARY KEY,
    Question text,
    Answer text
);

insert into admin value("admin", "admin");

insert into CustomerRep value ("repuser", "reppassword");

insert into customer value ("Bob Fitzgerald", "bobfitz1966", "password1234");
insert into customer value ("Mary Smith", "msmith221", "password55");
insert into customer value ("Benjamin O'Connor", "bennyoconnor74", "password777");
insert into customer value ("Joe Schmidt", "joeyschmidt26", "password123123");
insert into customer value ("Alice Andrews", "allieandrews22", "password5432");

insert into Airline values ("AA", "American Airlines"), ("SA", "Southwest Airlines"), ("DA", "Delta Airlines"), ("FA", "Fast Airlines"), ("JA", "Jaguar Airlines");
insert into Aircraft values (150, "AA", "ATR 42"), (200, "AA", "Embraer"), (175, "SA", "Concorde"), (190, "SA", "Comac ARJ21"), (140, "DA", "Boeing 747"), (130, "DA", "Airbus A380"), (155, "FA", "Bombardier CRJ"), (145, "FA", "Boeing 777"), (135, "JA", "Antonov"), (150, "JA", "Beechcraft 1900");
insert into Airport values ("EWR", "Newark"), ("JFK", "John F. Kennedy"), ("LGA", "LaGuardia"), ("LHR", "Heathrow"), ("SEA", "Seattle-Tacoma"), ("MEX", "Mexico City");

insert into Flight value ("Monday,Wednesday", "Domestic", 150, "AA", 1, "EWR", "JFK", '2023-11-22 05:30:00', '2023-11-22 20:10:00');
insert into Flight value ("Monday,Wednesday", "Domestic", 200, "AA", 2, "JFK", "LGA", '2023-11-22 21:00:00', '2023-11-23 07:15:00');
insert into ticket value(11, "23", "Economy", 140.50, 20.00, "OneWay", 2);
insert into FlightsForTicket value(11, 150, "AA", 1);
insert into FlightsForTicket value(11, 200, "AA", 2);

insert into Flight value ("Tuesday,Thursday", "International", 130, "DA", 3, "SEA", "MEX", '2023-12-5 09:30:00', '2023-12-5 22:20:00');
insert into Flight value ("Tuesday,Thursday", "International", 140, "DA", 4, "MEX", "SEA", '2023-12-12 07:30:00', '2023-12-12 20:20:00');
insert into ticket value (12, "44", "Business", 155.25, 18.95, "RoundTrip", 5);
insert into FlightsForTicket value(12, 130, "DA", 3);
insert into FlightsForTicket value(12, 140, "DA", 4);

insert into flight value ("Monday,Wednesday,Friday", "Domestic", 145, "FA", 5, "EWR", "LGA", "2023-11-28 08:30:00", "2023-11-28 14:30:00");
insert into ticket value (13, 20, "First", 85.00, 13.30, "OneWay", 3);
insert into flightsforticket value (13, 145, "FA", 5);

select * from customerrep;
select * from aircraft;
select * from airline;
select * from airport;
select * from customer;
select * from customersforticket;
select * from flight;
select * from flightsforticket;
select * from questionsandanswers;
select * from ticket;
select * from tickethistory;
select * from waitinglistforticket;
