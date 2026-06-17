create database if not exists flashlogistics_dss
default character set utf8mb4
default collate utf8mb4_unicode_ci;

use flashlogistics_dss;

create table persona (
    id int auto_increment primary key,
    nombre varchar(100) not null,
    telefono varchar(20),
    activo boolean default true
) engine=innodb;

create table rol (
    id int auto_increment primary key,
    nombre varchar(50) not null unique,
    descripcion varchar(200),
    activo boolean default true
) engine=innodb;

create table cliente (
    id int primary key,
    direccion varchar(200) not null,
    foreign key (id) references persona(id) on delete cascade
) engine=innodb;

create table conductor (
    id int primary key,
    licencia varchar(30) not null unique,
    estado varchar(20) default 'disponible',
    foreign key (id) references persona(id) on delete cascade
) engine=innodb;

create table usuario (
    id int auto_increment primary key,
    email varchar(100) not null unique,
    contrasena_hash varchar(255) not null,
    ultimo_acceso datetime,
    activo boolean default true,
    persona_id int,
    rol_id int not null,
    foreign key (persona_id) references persona(id) on delete set null,
    foreign key (rol_id) references rol(id)
) engine=innodb;

create table pedido (
    id int auto_increment primary key,
    fecha date not null,
    direccion_entrega varchar(200) not null,
    producto varchar(100) not null,
    cantidad int not null check (cantidad > 0),
    estado varchar(20) default 'pendiente',
    fecha_entrega_estimada datetime,
    fecha_entrega_real datetime,
    activo boolean default true,
    cliente_id int not null,
    foreign key (cliente_id) references cliente(id)
) engine=innodb;

create table vehiculo (
    id int auto_increment primary key,
    placa varchar(20) not null unique,
    marca varchar(50) not null,
    capacidad decimal(10,2) not null check (capacidad > 0),
    estado varchar(20) default 'disponible',
    activo boolean default true,
    conductor_id int,
    foreign key (conductor_id) references conductor(id) on delete set null
) engine=innodb;

create table ruta (
    id int auto_increment primary key,
    origen varchar(200) not null,
    destino varchar(200) not null,
    distancia_km decimal(10,2) not null check (distancia_km > 0),
    costo_estimado decimal(10,2) not null check (costo_estimado > 0),
    costo_real decimal(10,2),
    tiempo_estimado int not null check (tiempo_estimado > 0),
    tiempo_real int,
    activo boolean default true,
    pedido_id int not null unique,
    conductor_id int,
    foreign key (pedido_id) references pedido(id),
    foreign key (conductor_id) references conductor(id) on delete set null
) engine=innodb;

create table ubicaciongps (
    id int auto_increment primary key,
    latitud decimal(10,8) not null,
    longitud decimal(11,8) not null,
    timestamp datetime not null default current_timestamp,
    ruta_id int,
    foreign key (ruta_id) references ruta(id) on delete cascade
) engine=innodb;

create table entrega (
    id int auto_increment primary key,
    fecha datetime not null default current_timestamp,
    estado varchar(20) default 'pendiente',
    firma varchar(200),
    pedido_id int,
    foreign key (pedido_id) references pedido(id) on delete set null
) engine=innodb;

create table consumocombustible (
    id int auto_increment primary key,
    cantidad decimal(10,2) not null check (cantidad > 0),
    fecha date not null,
    costo decimal(10,2) not null check (costo > 0),
    vehiculo_id int not null,
    foreign key (vehiculo_id) references vehiculo(id) on delete cascade
) engine=innodb;

create table notificacion (
    id int auto_increment primary key,
    destinatario varchar(100) not null,
    mensaje text not null,
    tipo varchar(30) not null,
    fecha_envio datetime not null default current_timestamp,
    ruta_id int,
    foreign key (ruta_id) references ruta(id) on delete set null
) engine=innodb;

create table reporte (
    id int auto_increment primary key,
    fecha_generacion datetime not null default current_timestamp,
    tipo varchar(50) not null,
    indicadores text
) engine=innodb;