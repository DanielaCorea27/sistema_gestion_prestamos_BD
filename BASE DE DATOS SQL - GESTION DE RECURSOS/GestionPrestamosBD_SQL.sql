USE [master]
GO
/****** Object:  Database [BD_GestionPrestamo_ITCA]    Script Date: 15/6/2025 17:23:09 ******/
CREATE DATABASE [BD_GestionPrestamo_ITCA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BD_GestionPrestamo_ITCA', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BD_GestionPrestamo_ITCA.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BD_GestionPrestamo_ITCA_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BD_GestionPrestamo_ITCA_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BD_GestionPrestamo_ITCA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET ARITHABORT OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET  MULTI_USER 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET QUERY_STORE = ON
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BD_GestionPrestamo_ITCA]
GO
/****** Object:  User [tecnico]    Script Date: 15/6/2025 17:23:09 ******/
CREATE USER [tecnico] FOR LOGIN [tecnico_DB] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [docente]    Script Date: 15/6/2025 17:23:09 ******/
CREATE USER [docente] FOR LOGIN [docente_DB] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [rol_tecnicos]    Script Date: 15/6/2025 17:23:09 ******/
CREATE ROLE [rol_tecnicos]
GO
/****** Object:  DatabaseRole [rol_docentes]    Script Date: 15/6/2025 17:23:09 ******/
CREATE ROLE [rol_docentes]
GO
ALTER ROLE [rol_tecnicos] ADD MEMBER [tecnico]
GO
ALTER ROLE [rol_docentes] ADD MEMBER [docente]
GO
/****** Object:  UserDefinedTableType [dbo].[IdEquiposTableType]    Script Date: 15/6/2025 17:23:10 ******/
CREATE TYPE [dbo].[IdEquiposTableType] AS TABLE(
	[id_equipo] [varchar](10) NOT NULL,
	[fecha_devolucion_real] [datetime] NULL,
	[estado_devolucion] [text] NULL,
	PRIMARY KEY CLUSTERED 
(
	[id_equipo] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedFunction [dbo].[EquiposActivosBajoStock]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[EquiposActivosBajoStock] (@Cantidad INT, @Categoria VARCHAR(20))
RETURNS @EquipoStock TABLE (
    CATEGORIA VARCHAR(20),
	COD_EQUIPO VARCHAR(10),
	EQUIPO VARCHAR(100),
	MODELO VARCHAR(50),
	MARCA VARCHAR(50),
	DISPONIBILIDAD VARCHAR(20),
	FECHA_ADQUISICION DATE,
	CANTIDAD INT
	)
	AS 
	BEGIN
	INSERT INTO @EquipoStock
	SELECT C.nombre, E.id_equipo, E.nombre, E.modelo, E.marca, 
	E.estado, E.fecha_adquisicion, E.stock
	FROM EQUIPO E
	INNER JOIN CATEGORIA_EQUIPO C ON E.id_categoria = C.id_categoria
	WHERE E.estado != 'inactivo' AND E.stock <= @Cantidad AND C.nombre = @Categoria

	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[FILTRO_EQUIPOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FILTRO_EQUIPOS] (@Disponibilidad VARCHAR(20))
RETURNS @EquiposFiltrados TABLE (
	Categoria VARCHAR(50),
	CODIGO VARCHAR(10),
	EQUIPO VARCHAR(100),
	MODELO VARCHAR(50),
	MARCA VARCHAR(50),
	DISPONIBILIDAD VARCHAR(20),
	FECHA_ENTRADA DATE,
	CANTIDAD INT
	)
	AS 
	BEGIN
	INSERT INTO @EquiposFiltrados
	SELECT C.nombre , E.id_equipo, E.nombre, E.modelo, E.marca, E.estado, E.fecha_adquisicion, E.stock
	FROM EQUIPO E
	INNER JOIN CATEGORIA_EQUIPO C ON E.id_categoria = C.id_categoria
	WHERE E.estado = @Disponibilidad
	ORDER BY C.id_categoria;

	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[FILTRO_TECNICOS_MANTENIMIENTO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FILTRO_TECNICOS_MANTENIMIENTO] (@Tecnico VARCHAR(20))
RETURNS @TecnicosMantenimiento TABLE (
	NOMBRE_RESPONSABLE VARCHAR(100),
	APELLIDO_RESPONSABLE VARCHAR(100),
	CARNET VARCHAR(20),
	CONTACTO VARCHAR(20),
	COD_MANTENIMIENTO INT,
	COD_EQUIPO VARCHAR(10),
	EQUIPO VARCHAR(100),
	FECHA_INICIO DATE,
	FECHA_PROPUESTA DATE,
	FECHA_FIN DATE,
	TIPO_MANTENIMIENTO VARCHAR(50),
	DESCRIPCION TEXT,
	ESTADO VARCHAR(20)
	)
	AS 
	BEGIN
	INSERT INTO @TecnicosMantenimiento
	SELECT U.nombre, U.apellido, U.carnet, U.telefono, 
	HM.id_mantenimiento, HM.id_equipo, E.nombre,
	HM.fecha_inicio, HM.fecha_fin_programada, HM.fecha_fin_real, 
	HM.tipo_mantenimiento, HM.descripcion, HM.estado
	FROM USUARIO U
	INNER JOIN HISTORIAL_MANTENIMIENTO HM ON U.id_usuario = HM.id_responsable
	INNER JOIN EQUIPO E ON HM.id_equipo = E.id_equipo
	WHERE U.carnet = @Tecnico AND U.id_rol = 3

	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[FILTRO_USUARIOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FILTRO_USUARIOS] (@Rol VARCHAR(10))
RETURNS @UsuariosFiltrados TABLE (
	Nombre VARCHAR(100),
	Apellido VARCHAR(100),
	Identificacion VARCHAR(10),
	Carnet VARCHAR(20),
	Correo VARCHAR(100),
	Contacto VARCHAR(20)
	)
	AS 
	BEGIN
	INSERT INTO @UsuariosFiltrados
	SELECT U.nombre, U.apellido, U.dui, U.carnet, U.correo, U.telefono 
	FROM USUARIO U
	INNER JOIN ROLES R ON U.id_rol = R.id_rol
	WHERE R.rol = @Rol AND estado = 'activo';

	RETURN;
END;
GO
/****** Object:  Table [dbo].[USUARIO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USUARIO](
	[id_usuario] [int] IDENTITY(1,1) NOT NULL,
	[id_rol] [int] NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[apellido] [varchar](100) NOT NULL,
	[dui] [varchar](10) NULL,
	[carnet] [varchar](20) NULL,
	[correo] [varchar](100) NOT NULL,
	[telefono] [varchar](20) NULL,
	[estado] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EQUIPO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EQUIPO](
	[id_equipo] [varchar](10) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[modelo] [varchar](50) NULL,
	[marca] [varchar](50) NULL,
	[serie] [varchar](50) NULL,
	[estado] [varchar](20) NOT NULL,
	[id_categoria] [int] NOT NULL,
	[fecha_adquisicion] [date] NOT NULL,
	[stock] [int] NOT NULL,
UNIQUE NONCLUSTERED 
(
	[id_equipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SALON]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SALON](
	[id_salon] [int] IDENTITY(1,1) NOT NULL,
	[tipo_salon] [varchar](20) NOT NULL,
	[codigo] [varchar](10) NOT NULL,
	[ubicacion] [varchar](100) NULL,
	[capacidad] [int] NULL,
	[imagen] [varbinary](max) NULL,
	[id_responsable] [int] NOT NULL,
	[estado] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_salon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRESTAMO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRESTAMO](
	[id_prestamo] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario] [int] NOT NULL,
	[fecha_prestamo] [datetime] NOT NULL,
	[fecha_devolucion_programada] [datetime] NOT NULL,
	[estado] [varchar](20) NOT NULL,
	[id_salon] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_prestamo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_PRESTAMO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_PRESTAMO](
	[id_detalle_prestamo] [int] IDENTITY(1,1) NOT NULL,
	[id_prestamo] [int] NOT NULL,
	[id_equipo] [varchar](10) NOT NULL,
	[fecha_devolucion_real] [datetime] NULL,
	[estado_devolucion] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_detalle_prestamo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[PRESTAMOS_FINALIZADOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PRESTAMOS_FINALIZADOS] AS
SELECT S.tipo_salon AS SALON, P.id_prestamo AS COD_PRESTAMO,
U.nombre AS NOMBRE_PRESTATARIO, U.apellido AS APELLIDO_PRESTATARIO, 
U.carnet AS CARNET_PRESTATARIO, E.id_equipo AS COD_EQUIPO,
P.fecha_prestamo AS FECHA_PRESTAMO, 
DP.fecha_devolucion_real AS FECHA_ENTREGA, 
P.estado AS ESTADO_ENTREGA 
FROM PRESTAMO P
INNER JOIN USUARIO U ON P.id_usuario = U.id_usuario
INNER JOIN SALON S ON P.id_salon = S.id_salon
INNER JOIN DETALLE_PRESTAMO DP ON P.id_prestamo = DP.id_prestamo
INNER JOIN EQUIPO E ON DP.id_equipo = E.id_equipo
WHERE P.estado = 'finalizado';
GO
/****** Object:  Table [dbo].[CATEGORIA_EQUIPO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CATEGORIA_EQUIPO](
	[id_categoria] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[descripcion] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[INVENTARIO_EQUIPOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[INVENTARIO_EQUIPOS] AS
SELECT C.nombre AS Categoria , E.id_equipo AS CODIGO, E.nombre AS EQUIPO, E.modelo AS Modelo, E.marca AS Marca, E.estado AS Disponibilidad, E.fecha_adquisicion AS FECHA_ENTRADA, E.stock AS Cantidad 
FROM EQUIPO E
INNER JOIN CATEGORIA_EQUIPO C ON E.id_categoria = C.id_categoria;
GO
/****** Object:  View [dbo].[SALONES]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SALONES] AS
SELECT S.id_salon AS ID, S.tipo_salon AS SALON, U.nombre AS RESPONSABLE, S.codigo AS CODIGO, S.ubicacion AS UBICACION, S.capacidad AS CAPACIDAD, S.imagen AS COD_IMAGEN 
FROM SALON S
INNER JOIN USUARIO U ON S.id_responsable = U.id_usuario;
GO
/****** Object:  View [dbo].[PRESTAMOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PRESTAMOS] AS
SELECT S.tipo_salon AS SALON, P.id_prestamo AS COD_PRESTAMO, U.nombre AS NOMBRE_PRESTATARIO, U.apellido AS APELLIDO_PRESTATARIO, U.carnet AS CARNET_PRESTATARIO, P.fecha_prestamo AS FECHA_PRESTAMO, P.fecha_devolucion_programada AS FECHA_PROGRAMADA_ENTREGA, P.estado AS ESTADO_ENTREGA 
FROM PRESTAMO P
INNER JOIN USUARIO U ON P.id_usuario = U.id_usuario
INNER JOIN SALON S ON P.id_salon = S.id_salon;
GO
/****** Object:  View [dbo].[DETALLES_DEL_PRESTAMO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DETALLES_DEL_PRESTAMO] AS
SELECT U.nombre AS NOMBRE_PRESTATARIO, U.apellido AS APELLIDO_PRESTATARIO, U.carnet AS CARNET_PRESTATARIO, D.id_prestamo AS COD_PRESTAMO, D.id_equipo AS COD_EQUIPO, E.nombre AS EQUIPO, C.nombre AS CATEGORIA, P.fecha_prestamo AS FECHA_PRESTAMO, D.fecha_devolucion_real AS FECHA_DEVOLUCION, D.estado_devolucion AS ESTADO
FROM DETALLE_PRESTAMO D
INNER JOIN EQUIPO E ON D.id_equipo = E.id_equipo
INNER JOIN CATEGORIA_EQUIPO C ON E.id_categoria = C.id_categoria
INNER JOIN PRESTAMO P ON D.id_prestamo = P.id_prestamo
INNER JOIN USUARIO U ON P.id_usuario = U.id_usuario;
GO
/****** Object:  Table [dbo].[HISTORIAL_MANTENIMIENTO]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HISTORIAL_MANTENIMIENTO](
	[id_mantenimiento] [int] IDENTITY(1,1) NOT NULL,
	[id_equipo] [varchar](10) NOT NULL,
	[fecha_inicio] [date] NOT NULL,
	[fecha_fin_programada] [date] NOT NULL,
	[fecha_fin_real] [date] NULL,
	[tipo_mantenimiento] [varchar](50) NOT NULL,
	[descripcion] [text] NULL,
	[estado] [varchar](20) NOT NULL,
	[estado_equipo] [varchar](20) NULL,
	[id_responsable] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_mantenimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[MANTENIMIENTOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MANTENIMIENTOS] AS
SELECT U.nombre AS NOMBRE_RESPONSABLE, U.apellido AS RESPONSABLE, U.carnet AS CARNET_RESPONSABLE, HM.id_mantenimiento AS COD_MANTENIMIENTO, HM.id_equipo AS COD_EQUIPO, E.nombre AS EQUIPO, HM.fecha_inicio AS FECHA_INICIO, HM.fecha_fin_programada AS FECHA_PROPUESTA, HM.fecha_fin_real AS FECHA_FIN, HM.tipo_mantenimiento AS TIPO_MANTENIMIENTO, HM.descripcion AS DESCRIPCION, HM.estado AS ESTADO
FROM HISTORIAL_MANTENIMIENTO HM
INNER JOIN EQUIPO E ON HM.id_equipo = E.id_equipo
INNER JOIN USUARIO U ON HM.id_responsable = U.id_usuario;
GO
/****** Object:  View [dbo].[USUARIOS_INACTIVOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USUARIOS_INACTIVOS] AS
SELECT * FROM USUARIO
WHERE estado = 'inactivo';
GO
/****** Object:  View [dbo].[USUARIOS_ACTIVOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USUARIOS_ACTIVOS] AS
SELECT * FROM USUARIO
WHERE estado = 'activo';
GO
/****** Object:  View [dbo].[USUARIOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[USUARIOS] AS
SELECT * FROM USUARIO
GO
/****** Object:  View [dbo].[PRESTAMOS_ACTIVOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PRESTAMOS_ACTIVOS] AS
SELECT S.tipo_salon AS SALON, P.id_prestamo AS COD_PRESTAMO, U.nombre AS NOMBRE_PRESTATARIO, U.apellido AS APELLIDO_PRESTATARIO, U.carnet AS CARNET_PRESTATARIO, P.fecha_prestamo AS FECHA_PRESTAMO, P.fecha_devolucion_programada AS FECHA_PROGRAMADA_ENTREGA, P.estado AS ESTADO_ENTREGA 
FROM PRESTAMO P
INNER JOIN USUARIO U ON P.id_usuario = U.id_usuario
INNER JOIN SALON S ON P.id_salon = S.id_salon
WHERE P.estado = 'activo';
GO
/****** Object:  View [dbo].[PRESTAMOS_VENCIDOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PRESTAMOS_VENCIDOS] AS
SELECT S.tipo_salon AS SALON, P.id_prestamo AS COD_PRESTAMO, U.nombre AS NOMBRE_PRESTATARIO, U.apellido AS APELLIDO_PRESTATARIO, U.carnet AS CARNET_PRESTATARIO, P.fecha_prestamo AS FECHA_PRESTAMO, P.fecha_devolucion_programada AS FECHA_PROGRAMADA_ENTREGA, P.estado AS ESTADO_ENTREGA 
FROM PRESTAMO P
INNER JOIN USUARIO U ON P.id_usuario = U.id_usuario
INNER JOIN SALON S ON P.id_salon = S.id_salon
WHERE P.estado = 'vencido';
GO
/****** Object:  View [dbo].[MANTENIMIENTOS_PENDIENTES]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MANTENIMIENTOS_PENDIENTES] AS
SELECT U.nombre AS NOMBRE_RESPONSABLE, U.apellido AS RESPONSABLE, U.carnet AS CARNET_RESPONSABLE, HM.id_mantenimiento AS COD_MANTENIMIENTO, HM.id_equipo AS COD_EQUIPO, E.nombre AS EQUIPO, HM.fecha_inicio AS FECHA_INICIO, HM.fecha_fin_programada AS FECHA_PROPUESTA, HM.fecha_fin_real AS FECHA_FIN, HM.tipo_mantenimiento AS TIPO_MANTENIMIENTO, HM.descripcion AS DESCRIPCION, HM.estado AS ESTADO
FROM HISTORIAL_MANTENIMIENTO HM
INNER JOIN EQUIPO E ON HM.id_equipo = E.id_equipo
INNER JOIN USUARIO U ON HM.id_responsable = U.id_usuario
WHERE HM.estado = 'pendiente';
GO
/****** Object:  View [dbo].[MANTENIMIENTOS_COMPLETADOS]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MANTENIMIENTOS_COMPLETADOS] AS
SELECT U.nombre AS NOMBRE_RESPONSABLE, U.apellido AS RESPONSABLE, U.carnet AS CARNET_RESPONSABLE, HM.id_mantenimiento AS COD_MANTENIMIENTO, HM.id_equipo AS COD_EQUIPO, E.nombre AS EQUIPO, HM.fecha_inicio AS FECHA_INICIO, HM.fecha_fin_programada AS FECHA_PROPUESTA, HM.fecha_fin_real AS FECHA_FIN, HM.tipo_mantenimiento AS TIPO_MANTENIMIENTO, HM.descripcion AS DESCRIPCION, HM.estado AS ESTADO
FROM HISTORIAL_MANTENIMIENTO HM
INNER JOIN EQUIPO E ON HM.id_equipo = E.id_equipo
INNER JOIN USUARIO U ON HM.id_responsable = U.id_usuario
WHERE HM.estado = 'completado';
GO
/****** Object:  Table [dbo].[ROLES]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLES](
	[id_rol] [int] IDENTITY(1,1) NOT NULL,
	[rol] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRESTAMO] ADD  DEFAULT (getdate()) FOR [fecha_prestamo]
GO
ALTER TABLE [dbo].[SALON] ADD  DEFAULT ('activo') FOR [estado]
GO
ALTER TABLE [dbo].[DETALLE_PRESTAMO]  WITH CHECK ADD FOREIGN KEY([id_equipo])
REFERENCES [dbo].[EQUIPO] ([id_equipo])
GO
ALTER TABLE [dbo].[DETALLE_PRESTAMO]  WITH CHECK ADD FOREIGN KEY([id_prestamo])
REFERENCES [dbo].[PRESTAMO] ([id_prestamo])
GO
ALTER TABLE [dbo].[EQUIPO]  WITH CHECK ADD FOREIGN KEY([id_categoria])
REFERENCES [dbo].[CATEGORIA_EQUIPO] ([id_categoria])
GO
ALTER TABLE [dbo].[HISTORIAL_MANTENIMIENTO]  WITH CHECK ADD FOREIGN KEY([id_equipo])
REFERENCES [dbo].[EQUIPO] ([id_equipo])
GO
ALTER TABLE [dbo].[HISTORIAL_MANTENIMIENTO]  WITH CHECK ADD FOREIGN KEY([id_responsable])
REFERENCES [dbo].[USUARIO] ([id_usuario])
GO
ALTER TABLE [dbo].[PRESTAMO]  WITH CHECK ADD FOREIGN KEY([id_salon])
REFERENCES [dbo].[SALON] ([id_salon])
GO
ALTER TABLE [dbo].[PRESTAMO]  WITH CHECK ADD FOREIGN KEY([id_usuario])
REFERENCES [dbo].[USUARIO] ([id_usuario])
GO
ALTER TABLE [dbo].[SALON]  WITH CHECK ADD FOREIGN KEY([id_responsable])
REFERENCES [dbo].[USUARIO] ([id_usuario])
GO
ALTER TABLE [dbo].[USUARIO]  WITH CHECK ADD FOREIGN KEY([id_rol])
REFERENCES [dbo].[ROLES] ([id_rol])
GO
ALTER TABLE [dbo].[EQUIPO]  WITH CHECK ADD CHECK  (([estado]='inactivo' OR [estado]='mantenimiento' OR [estado]='prestado' OR [estado]='disponible'))
GO
ALTER TABLE [dbo].[HISTORIAL_MANTENIMIENTO]  WITH CHECK ADD CHECK  (([estado]='completado' OR [estado]='pendiente'))
GO
ALTER TABLE [dbo].[HISTORIAL_MANTENIMIENTO]  WITH CHECK ADD CHECK  (([estado_equipo]='inactivo' OR [estado_equipo]='disponible'))
GO
ALTER TABLE [dbo].[HISTORIAL_MANTENIMIENTO]  WITH CHECK ADD CHECK  (([tipo_mantenimiento]='correctivo' OR [tipo_mantenimiento]='preventivo'))
GO
ALTER TABLE [dbo].[PRESTAMO]  WITH CHECK ADD CHECK  (([estado]='vencido' OR [estado]='finalizado' OR [estado]='activo'))
GO
ALTER TABLE [dbo].[SALON]  WITH CHECK ADD CHECK  (([estado]='inactivo' OR [estado]='activo'))
GO
ALTER TABLE [dbo].[SALON]  WITH CHECK ADD CHECK  (([tipo_salon]='Salon de Conferencia' OR [tipo_salon]='Salon de Clase' OR [tipo_salon]='Laboratorio' OR [tipo_salon]='Centro de Cómputo'))
GO
ALTER TABLE [dbo].[USUARIO]  WITH CHECK ADD CHECK  (([estado]='inactivo' OR [estado]='activo'))
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarDetallePrestamo]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ActualizarDetallePrestamo]
    @id_detalle_prestamo INT,
    @id_prestamo INT,
    @id_equipo VARCHAR(10),
    @fecha_devolucion_real DATETIME,
    @estado_devolucion TEXT
AS
BEGIN
    UPDATE DETALLE_PRESTAMO
    SET id_prestamo = @id_prestamo,
        id_equipo = @id_equipo,
        fecha_devolucion_real = @fecha_devolucion_real,
        estado_devolucion = @estado_devolucion
    WHERE id_detalle_prestamo = @id_detalle_prestamo;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarDevolucion]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ActualizarDevolucion]
    @id_detalle_prestamo INT,
    @fecha_devolucion_real DATETIME,
    @estado_devolucion TEXT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar si el detalle de préstamo existe
        IF NOT EXISTS (
            SELECT 1
            FROM DETALLE_PRESTAMO
            WHERE id_detalle_prestamo = @id_detalle_prestamo
        )
        BEGIN
            RAISERROR('El detalle de préstamo no existe.', 16, 1);
            RETURN;
        END

        -- Actualizar la fecha de devolución real y el estado de devolución
        UPDATE DETALLE_PRESTAMO
        SET 
            fecha_devolucion_real = @fecha_devolucion_real,
            estado_devolucion = @estado_devolucion
        WHERE id_detalle_prestamo = @id_detalle_prestamo;

        PRINT 'Devolución registrada correctamente.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarEquipo]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ActualizarEquipo]
    @id_equipo VARCHAR(10),
    @nombre VARCHAR(100),
    @modelo VARCHAR(50),
    @marca VARCHAR(50),
    @serie VARCHAR(50),
    @estado VARCHAR(20),
    @id_categoria INT,
    @fecha_adquisicion DATE,
    @stock INT
AS
BEGIN
    UPDATE EQUIPO
    SET nombre = @nombre,
        modelo = @modelo,
        marca = @marca,
        serie = @serie,
        estado = @estado,
        id_categoria = @id_categoria,
        fecha_adquisicion = @fecha_adquisicion,
        stock = @stock
    WHERE id_equipo = @id_equipo;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarHistorialMantenimiento]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---SP PARA FINALIZAR MANTENIMIENTO
	CREATE PROCEDURE [dbo].[sp_ActualizarHistorialMantenimiento]
    @id_mantenimiento INT,
    @fecha_fin_real DATE = NULL,
    @descripcion TEXT = NULL,
    @estado_equipo VARCHAR(20) = NULL
AS
BEGIN
    UPDATE HISTORIAL_MANTENIMIENTO
    SET
        fecha_fin_real = ISNULL(@fecha_fin_real, fecha_fin_real),
        descripcion = ISNULL(@descripcion, descripcion),
        estado_equipo = ISNULL(@estado_equipo, estado_equipo)
    WHERE id_mantenimiento = @id_mantenimiento;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarPrestamo]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ActualizarPrestamo]
    @id_prestamo INT,
    @id_usuario INT,
    @fecha_prestamo DATETIME,
    @fecha_devolucion_programada DATETIME,
    @estado VARCHAR(20),
    @id_salon INT
AS
BEGIN
    UPDATE PRESTAMO
    SET id_usuario = @id_usuario,
        fecha_prestamo = @fecha_prestamo,
        fecha_devolucion_programada = @fecha_devolucion_programada,
        estado = @estado,
        id_salon = @id_salon
    WHERE id_prestamo = @id_prestamo;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarSalon]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_ActualizarSalon]
    @id_salon INT,
    @tipo_salon VARCHAR(20),
    @codigo VARCHAR(10),
    @ubicacion VARCHAR(100),
    @capacidad INT,
    @imagen VARBINARY(MAX),
    @id_responsable INT
AS
BEGIN
    UPDATE SALON
    SET tipo_salon = @tipo_salon,
        codigo = @codigo,
        ubicacion = @ubicacion,
        capacidad = @capacidad,
        imagen = @imagen,
        id_responsable = @id_responsable
    WHERE id_salon = @id_salon;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarUsuario]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ActualizarUsuario]
    @id_usuario INT,
    @id_rol INT,
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @dui VARCHAR(10),
    @carnet VARCHAR(20),
    @correo VARCHAR(100),
    @telefono VARCHAR(20),
    @estado VARCHAR(20)
AS
BEGIN
    UPDATE USUARIO
    SET id_rol = @id_rol,
        nombre = @nombre,
        apellido = @apellido,
        dui = @dui,
        carnet = @carnet,
        correo = @correo,
        telefono = @telefono,
        estado = @estado
    WHERE id_usuario = @id_usuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarVencidos]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP para actualizar préstamos vencidos
CREATE PROCEDURE [dbo].[sp_ActualizarVencidos]
AS
BEGIN
    UPDATE P
    SET P.estado = 'vencido'
    FROM PRESTAMO P
    WHERE P.estado <> 'vencido'
      AND P.fecha_devolucion_programada < GETDATE()
      AND EXISTS (
          SELECT 1
          FROM DETALLE_PRESTAMO D
          WHERE D.id_prestamo = P.id_prestamo
            AND D.fecha_devolucion_real IS NULL
      );

    PRINT 'Préstamos vencidos actualizados';
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_BuscarEquipos]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BuscarEquipos]
    @Nombre VARCHAR(100) = NULL,
    @Estado VARCHAR(20) = NULL,
    @Categoria VARCHAR(50) = NULL
AS
BEGIN
    -- Validar que @Estado sea correcto o NULL
    IF @Estado IS NOT NULL AND @Estado NOT IN ('disponible', 'prestado', 'mantenimiento', 'inactivo')
    BEGIN
        RAISERROR('Estado no válido. Debe ser disponible, prestado, mantenimiento o inactivo.', 16, 1);
        RETURN;
    END;

    SELECT E.id_equipo, E.nombre, E.modelo, E.marca, E.serie, E.estado, C.nombre AS categoria, E.fecha_adquisicion, E.stock
    FROM EQUIPO E
    INNER JOIN CATEGORIA_EQUIPO C ON E.id_categoria = C.id_categoria
    WHERE (@Nombre IS NULL OR E.nombre LIKE '%' + @Nombre + '%')
      AND (@Estado IS NULL OR E.estado = @Estado)
      AND (@Categoria IS NULL OR C.nombre LIKE '%' + @Categoria + '%');
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_BuscarUsuarios]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BuscarUsuarios]
    @Nombre VARCHAR(100) = NULL,
    @Apellido VARCHAR(100) = NULL,
    @Correo VARCHAR(100) = NULL
AS
BEGIN
    -- Validar longitud de @Nombre
    IF @Nombre IS NOT NULL AND LEN(@Nombre) > 100
    BEGIN
        RAISERROR('El nombre no debe exceder 100 caracteres.', 16, 1);
        RETURN;
    END;

    -- Validar longitud de @Apellido
    IF @Apellido IS NOT NULL AND LEN(@Apellido) > 100
    BEGIN
        RAISERROR('El apellido no debe exceder 100 caracteres.', 16, 1);
        RETURN;
    END;

    -- Validar longitud de @Correo
    IF @Correo IS NOT NULL AND LEN(@Correo) > 100
    BEGIN
        RAISERROR('El correo no debe exceder 100 caracteres.', 16, 1);
        RETURN;
    END;

    SELECT U.id_usuario, R.rol, U.nombre, U.apellido, U.dui, U.carnet, U.correo, U.telefono, U.estado
    FROM USUARIO U
    INNER JOIN ROLES R ON U.id_rol = R.id_rol
    WHERE (@Nombre IS NULL OR U.nombre LIKE '%' + @Nombre + '%')
      AND (@Apellido IS NULL OR U.apellido LIKE '%' + @Apellido + '%')
      AND (@Correo IS NULL OR U.correo LIKE '%' + @Correo + '%');
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_CrearUsuario]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREAR USUARIO
CREATE PROCEDURE [dbo].[sp_CrearUsuario]
  @id_rol INT,
  @nombre VARCHAR(100),
  @apellido VARCHAR(100),
  @dui VARCHAR(10) = NULL,
  @carnet VARCHAR(20) = NULL,
  @correo VARCHAR(100),
  @telefono VARCHAR(20) = NULL,
  @estado VARCHAR(20) = 'activo'
  AS
BEGIN
    BEGIN TRY
        INSERT INTO USUARIO (id_rol, nombre, apellido, dui, carnet, correo, telefono, estado)
        VALUES (@id_rol, @nombre, @apellido, @dui, @carnet, @correo, @telefono, @estado);
        
        SELECT SCOPE_IDENTITY() AS id_usuario, 'Usuario creado exitosamente' AS mensaje;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS error;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarEquipoLogico]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_EliminarEquipoLogico]
    @id_equipo VARCHAR(10)
AS
BEGIN
    UPDATE EQUIPO
    SET estado = 'inactivo'
    WHERE id_equipo = @id_equipo;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarSalon]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_EliminarSalon]
    @id_salon INT
AS
BEGIN
    UPDATE SALON
    SET estado = 'inactivo'
    WHERE id_salon = @id_salon;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarSalonLogico]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_EliminarSalonLogico]
    @id_salon INT
AS
BEGIN
    UPDATE SALON
    SET estado = 'inactivo'
    WHERE id_salon = @id_salon;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarUsuarioLogico]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_EliminarUsuarioLogico]
    @id_usuario INT
AS
BEGIN
    UPDATE USUARIO
    SET estado = 'inactivo'
    WHERE id_usuario = @id_usuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarCategoriaEquipo]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarCategoriaEquipo]
    @nombre VARCHAR(50),
    @descripcion TEXT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación: Nombre no puede ser nulo o vacío
    IF (@nombre IS NULL OR LTRIM(RTRIM(@nombre)) = '')
    BEGIN
        RAISERROR('El nombre de la categoría no puede estar vacío.', 16, 1);
        RETURN;
    END

    -- Validación: No permitir nombres duplicados
    IF EXISTS (
        SELECT 1 FROM CATEGORIA_EQUIPO WHERE LTRIM(RTRIM(nombre)) = LTRIM(RTRIM(@nombre))
    )
    BEGIN
        RAISERROR('Ya existe una categoría con ese nombre.', 16, 1);
        RETURN;
    END

    -- Inserción
    INSERT INTO CATEGORIA_EQUIPO (nombre, descripcion)
    VALUES (LTRIM(RTRIM(@nombre)), @descripcion);

    -- Mostrar lo insertado
    SELECT TOP 1 *
    FROM CATEGORIA_EQUIPO
    WHERE nombre = LTRIM(RTRIM(@nombre))
    ORDER BY id_categoria DESC;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarEquipo]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarEquipo]
    @id_equipo VARCHAR(10),
    @nombre VARCHAR(100),
    @modelo VARCHAR(50),
    @marca VARCHAR(50),
    @serie VARCHAR(50),
    @estado VARCHAR(20),
    @id_categoria INT,
    @fecha_adquisicion DATE,
    @stock INT
AS
BEGIN
    SET NOCOUNT ON;

    -- evitar insertar IDS vacios
    IF (@id_equipo IS NULL OR LTRIM(RTRIM(@id_equipo)) = '')
    BEGIN
        RAISERROR('El ID del equipo no puede estar vacío.', 16, 1);
        RETURN;
    END

    -- evitar ID duplicado
    IF EXISTS (SELECT 1 FROM EQUIPO WHERE id_equipo = @id_equipo)
    BEGIN
        RAISERROR('El ID del equipo ya existe.', 16, 1);
        RETURN;
    END

    -- validar si la categoría existe 
    IF NOT EXISTS (SELECT 1 FROM CATEGORIA_EQUIPO WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('La categoría especificada no existe.', 16, 1);
        RETURN;
    END

    -- validacion de estados 
    IF (@estado NOT IN ('disponible', 'prestado', 'mantenimiento', 'inactivo'))
    BEGIN
        RAISERROR('El estado ingresado no es válido.', 16, 1);
        RETURN;
    END

    -- insertamos de ser las validaciones correctas
    INSERT INTO EQUIPO (id_equipo, nombre, modelo, marca, serie, estado, id_categoria, fecha_adquisicion, stock)
    VALUES (
        LTRIM(RTRIM(@id_equipo)), LTRIM(RTRIM(@nombre)), @modelo, @marca, @serie, @estado,
        @id_categoria, @fecha_adquisicion, @stock
    );

    -- Mostrar equipo insertado
    SELECT * FROM EQUIPO WHERE id_equipo = @id_equipo;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarPrestamoCompleto]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_InsertarPrestamoCompleto]
    @id_usuario INT,
    @fecha_devolucion_programada DATE,
    @id_salon INT,
    @equipos dbo.IdEquiposTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar usuario activo
        IF EXISTS (
            SELECT 1 FROM USUARIO WHERE id_usuario = @id_usuario AND estado = 'inactivo'
        )
        BEGIN
            RAISERROR('El usuario está inactivo y no puede realizar préstamos.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar equipos disponibles
        IF EXISTS (
            SELECT 1
            FROM @equipos e
            JOIN EQUIPO eq ON e.id_equipo = eq.id_equipo
            WHERE eq.estado <> 'disponible'
        )
        BEGIN
            RAISERROR('Uno o más equipos no están disponibles para préstamo.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar préstamo y obtener nuevo ID con OUTPUT
        DECLARE @InsertedPrestamo TABLE (id_prestamo INT);

        INSERT INTO PRESTAMO (id_usuario, fecha_prestamo, fecha_devolucion_programada, estado, id_salon)
        OUTPUT inserted.id_prestamo INTO @InsertedPrestamo
        VALUES (@id_usuario, GETDATE(), @fecha_devolucion_programada, 'activo', @id_salon);

        DECLARE @nuevo_id_prestamo INT;
        SELECT TOP 1 @nuevo_id_prestamo = id_prestamo FROM @InsertedPrestamo;

        -- Insertar detalles con fecha_devolucion_real y estado_devolucion
        INSERT INTO DETALLE_PRESTAMO (id_prestamo, id_equipo, fecha_devolucion_real, estado_devolucion)
        SELECT @nuevo_id_prestamo, id_equipo, fecha_devolucion_real, estado_devolucion FROM @equipos;

        -- Actualizar estado equipos a 'prestado'
        UPDATE EQUIPO
        SET estado = 'prestado'
        WHERE id_equipo IN (SELECT id_equipo FROM @equipos);

        COMMIT TRANSACTION;

        -- Retornar el nuevo id del préstamo
        SELECT @nuevo_id_prestamo AS id_prestamo;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarRol]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarRol]
    @rol VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- no haber roles vacíos
    IF (@rol IS NULL OR LTRIM(RTRIM(@rol)) = '')
    BEGIN
        RAISERROR('El nombre del rol no puede estar vacío.', 16, 1);
        RETURN;
    END

    -- evitar roles duplicados
    IF EXISTS (SELECT 1 FROM ROLES WHERE LTRIM(RTRIM(rol)) = LTRIM(RTRIM(@rol)))
    BEGIN
        RAISERROR('El rol ya existe.', 16, 1);
        RETURN;
    END

    -- lo insertamos
    INSERT INTO ROLES (rol) VALUES (LTRIM(RTRIM(@rol)));

    -- Mostramos el  rol insertado
    SELECT TOP 1 * FROM ROLES
    WHERE rol = LTRIM(RTRIM(@rol))
    ORDER BY id_rol DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarSalon]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarSalon]
    @tipo_salon VARCHAR(20),
    @codigo VARCHAR(10),
    @ubicacion VARCHAR(100),
    @capacidad INT,
    @imagen VARBINARY(MAX) = NULL,
    @id_responsable INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar tipo de salón permitido
    IF @tipo_salon NOT IN ('Centro de Cómputo', 'Laboratorio', 'Salon de Clase', 'Salon de Conferencia')
    BEGIN
        RAISERROR('Tipo de salón no válido.', 16, 1);
        RETURN;
    END

    -- Validar código no vacío
    IF (@codigo IS NULL OR LTRIM(RTRIM(@codigo)) = '')
    BEGIN
        RAISERROR('El código del salón no puede estar vacío.', 16, 1);
        RETURN;
    END

    -- Validar código único
    IF EXISTS (SELECT 1 FROM SALON WHERE codigo = @codigo)
    BEGIN
        RAISERROR('Ya existe un salón con ese código.', 16, 1);
        RETURN;
    END

    -- Validar que el responsable exista y tenga rol permitido
    IF NOT EXISTS (
        SELECT 1 FROM USUARIO 
        WHERE id_usuario = @id_responsable 
        AND id_rol IN (
            SELECT id_rol FROM ROLES WHERE rol IN ('docente', 'técnico', 'admin')
        )
    )
    BEGIN
        RAISERROR('El responsable debe tener rol de docente, técnico o administrador.', 16, 1);
        RETURN;
    END

    -- Validar capacidad positiva
    IF @capacidad <= 0
    BEGIN
        RAISERROR('La capacidad debe ser un número positivo.', 16, 1);
        RETURN;
    END

    -- Inserción
    INSERT INTO SALON (tipo_salon, codigo, ubicacion, capacidad, imagen, id_responsable)
    VALUES (
        LTRIM(RTRIM(@tipo_salon)),
        LTRIM(RTRIM(@codigo)),
        @ubicacion,
        @capacidad,
        @imagen,
        @id_responsable
    );

    -- Mostrar el salón insertado
    SELECT * FROM SALON WHERE codigo = @codigo;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarMantenimiento]    Script Date: 15/6/2025 17:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RegistrarMantenimiento]
    @id_equipo VARCHAR(10),
    @fecha_inicio DATE,
    @fecha_fin_programada DATE,
    @fecha_fin_real DATE = NULL,  
    @tipo_mantenimiento VARCHAR(50),
    @descripcion TEXT,
    @estado VARCHAR(20),
	@estado_equipo VARCHAR(20),
    @id_responsable INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar que el equipo exista
        IF NOT EXISTS (
            SELECT 1 FROM EQUIPO WHERE id_equipo = @id_equipo
        )
        BEGIN
            RAISERROR('El equipo especificado no existe.', 16, 1);
            RETURN;
        END

        -- Validar que el responsable exista
        IF NOT EXISTS (
            SELECT 1 FROM USUARIO WHERE id_usuario = @id_responsable
        )
        BEGIN
            RAISERROR('El usuario responsable no existe.', 16, 1);
            RETURN;
        END

        -- Validar tipo de mantenimiento
        IF @tipo_mantenimiento NOT IN ('preventivo', 'correctivo')
        BEGIN
            RAISERROR('El tipo de mantenimiento no es válido.', 16, 1);
            RETURN;
        END

        -- Validar estado
        IF @estado NOT IN ('pendiente', 'completado')
        BEGIN
            RAISERROR('El estado no es válido.', 16, 1);
            RETURN;
        END

        -- Insertar el registro con la fecha fin real si se proporciona
        INSERT INTO HISTORIAL_MANTENIMIENTO (
            id_equipo, fecha_inicio, fecha_fin_programada, fecha_fin_real,
            tipo_mantenimiento, descripcion, estado, estado_equipo, id_responsable
        )
        VALUES (
            @id_equipo, @fecha_inicio, @fecha_fin_programada, @fecha_fin_real,
            @tipo_mantenimiento, @descripcion, @estado, @estado_equipo, @id_responsable
        );

        PRINT 'Mantenimiento registrado correctamente.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
USE [master]
GO
ALTER DATABASE [BD_GestionPrestamo_ITCA] SET  READ_WRITE 
GO
