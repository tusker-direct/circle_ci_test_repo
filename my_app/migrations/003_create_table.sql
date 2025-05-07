use my_app;

CREATE DATABASE IF NOT EXISTS cars (
	id int primary key auto_increment,
	brand varchar(255) not null,
	model varchar(255) not null,
	year int not null,
	price decimal(10, 2) not null
);
