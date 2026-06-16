# FlashLogistics DSS

Sistema de apoyo a la toma de decisiones (DSS) para optimización de rutas de distribución y trazabilidad en tiempo real de flotas.

**Repositorio:** https://github.com/saaay13/flashlogistics-pbb
**GitHub Project (Kanban):** https://github.com/users/saaay13/projects/10/views/1

## Épicas

| ID | Nombre | Descripción |
|----|--------|-------------|
| EP01 | Gestión de Datos | Administración de pedidos, flota y conductores |
| EP02 | Motor de Rutas | Algoritmo de optimización y cálculo de costos |
| EP03 | Monitoreo GPS | Seguimiento en tiempo real y geolocalización |
| EP04 | Dashboard y Reportes | Indicadores clave y toma de decisiones |
| EP05 | Notificaciones | Alertas automáticas a clientes y despachadores |
| EP06 | App Conductores | Aplicación móvil para el equipo de reparto |

## Product Backlog

13 Historias de Usuario priorizadas en GitHub Projects.

## Formulario de Refinamiento y Definition of Ready (DoR)

| Sección | Especificaciones |
|---------|-----------------|
| Squad | Equipo FlashLogistics |
| Proyecto | FlashLogistics DSS |

**Definition of Ready (DoR)** - Criterios que debe cumplir una HU antes del desarrollo:
- La historia tiene criterios de aceptación claros
- La historia ha sido estimada en Story Points
- Existe un Diagrama de Secuencia que explica la lógica compleja
- Los requisitos de datos están identificados
- Los actores del sistema están definidos
- Los flujos alternativos y errores están documentados
- La historia aporta valor al negocio
- La historia puede completarse dentro de un Sprint
- Cumple principios de sostenibilidad y eficiencia operativa

### Historia Core 1: HU03 - Optimización Automática de Rutas

**Descripción:** Como Gerente, quiero que el sistema optimice rutas automáticamente con un clic, para reducir el tiempo de planificación de 1 hora a 1 minuto.
**Story Points:** 8 puntos

**Lógica del algoritmo:** El sistema recibe los pedidos pendientes del día, consulta las ubicaciones GPS de los vehículos disponibles, obtiene distancias y condiciones de tráfico actual desde la API de Mapas, ejecuta un algoritmo de optimización y genera la mejor ruta disponible para cada conductor.

**Requisitos de datos:** Pedido, Vehículo, Ruta, Conductor, UbicaciónGPS
**ODS:** ODS 9 - Industria, Innovación e Infraestructura

### Historia Core 2: HU07 - Dashboard de Indicadores

**Descripción:** Como Gerente, quiero visualizar KPIs relacionados con entregas a tiempo y consumo de combustible, para tomar decisiones informadas.
**Story Points:** 5 puntos

**Lógica del algoritmo:** El sistema consulta registros históricos de entregas y consumo de combustible, calcula indicadores de desempeño y presenta gráficos y métricas en tiempo real en el dashboard.

**Requisitos de datos:** Entrega, ConsumoCombustible, Vehículo, Reporte
**ODS:** ODS 8 - Trabajo Decente y Crecimiento Económico

### Historia Core 3: HU10 - Alertas por Retrasos

**Descripción:** Como Gerente, quiero recibir alertas cuando un pedido presente retrasos, para tomar acciones correctivas oportunamente.
**Story Points:** 5 puntos

**Lógica del algoritmo:** El sistema compara el ETA con la hora real de entrega. Si la desviación supera los 15 minutos, genera una alerta en el dashboard y envía una notificación.

**Requisitos de datos:** Pedido, Ruta, ETA, Notificación
**ODS:** ODS 9 - Industria, Innovación e Infraestructura

## Modelo de Contexto

Actores del sistema: Gerente, Despachador, Administrador, Conductor, Cliente
Sistemas externos: API de Mapas, Sistema GPS, Servicio de Notificaciones

```plantuml
@startuml
skinparam linetype ortho
skinparam componentStyle rectangle

rectangle "FlashLogistics DSS" {

    actor Gerente
    actor Despachador
    actor Admin
    actor Conductor
    actor Cliente

    rectangle "SISTEMA" as Sistema {
        component "Optimizar rutas"
        component "Dashboard KPIs"
        component "Registrar pedidos"
        component "Monitoreo GPS"
        component "Notificaciones"
        component "App Conductores"
        component "Rastrear pedido"
        component "Gestión de datos"
        component "Alertas retrasos"
    }

    Gerente -- Sistema
    Despachador -- Sistema
    Admin -- Sistema
    Conductor -- Sistema
    Cliente -- Sistema

    rectangle "SISTEMAS EXTERNOS" {

        component "API de Mapas" as API
        component "Sistema GPS" as GPS
        component "Servicio de Notificaciones" as SN
    }

    Sistema -- API
    Sistema -- GPS
    Sistema -- SN
}

@enduml
```

### Diagrama de Casos de Uso Detallado - HU03: Optimización Automática de Rutas

```plantuml
@startuml
left to right direction

actor Gerente
actor "API de Mapas" as MAP
actor "Sistema GPS" as GPS

rectangle "FlashLogistics DSS" {

  usecase "Optimizar rutas" as U1
  usecase "Consultar datos mapas" as U2
  usecase "Obtener coordenadas GPS" as U3
  usecase "Generar ruta optimizada" as U4
}

Gerente -- U1

U1 ..> U2 : <<include>>
U1 ..> U3 : <<include>>
U1 ..> U4 : <<include>>

MAP -- U2
GPS -- U3

@enduml
```

### Diagrama de Casos de Uso Detallado - HU07: Dashboard de Indicadores

```plantuml
@startuml
left to right direction

actor Gerente
actor "Sistema BD" as BD

rectangle "FlashLogistics DSS" {

  usecase "Ver KPIs en dashboard" as U1
  usecase "Calcular indicadores" as U2
  usecase "Consultar datos historicos" as U3
  usecase "Generar reportes semanales" as U4
}

Gerente -- U1

U1 ..> U2 : <<include>>
U1 ..> U4 : <<extend>>
U2 ..> U3 : <<include>>

BD -- U3

@enduml
```

### Diagrama de Casos de Uso Detallado - HU10: Alertas por Retrasos

```plantuml
@startuml
left to right direction

actor Gerente
actor "Sistema GPS" as GPS
actor "Servicio Notificaciones" as NOTIF

rectangle "FlashLogistics DSS" {

  usecase "Recibir alerta de retraso" as U1
  usecase "Monitorear ETA" as U2
  usecase "Consultar ubicacion GPS" as U3
  usecase "Enviar notificacion" as U4
}

Gerente -- U1

U1 ..> U2 : <<include>>
U1 ..> U4 : <<include>>
U2 ..> U3 : <<include>>

GPS -- U3
NOTIF -- U4

@enduml
```

## Diagramas de Secuencia

### HU03 - Optimización Automática de Rutas

```plantuml
@startuml
actor Gerente
boundary Interfaz
control Controlador
participant "API Mapas" as MAP
participant GPS
database BD

Gerente -> Interfaz : Clic "Optimizar"
activate Interfaz

Interfaz -> Controlador : Solicitar optimizacion
activate Controlador

Controlador -> MAP : Obtener trafico
activate MAP
MAP --> Controlador : Datos trafico
deactivate MAP

Controlador -> GPS : Obtener coordenadas
activate GPS
GPS --> Controlador : Coordenadas
deactivate GPS

Controlador -> BD : Consultar pedidos
activate BD
BD --> Controlador : Lista pedidos
deactivate BD

Controlador -> Controlador : Ejecutar algoritmo

Controlador -> BD : Guardar ruta optima
activate BD
BD --> Controlador : OK
deactivate BD

Controlador --> Interfaz : Ruta optimizada
deactivate Controlador

Interfaz --> Gerente : Mostrar mapa
deactivate Interfaz

@enduml
```

### HU07 - Dashboard de Indicadores

```plantuml
@startuml
actor Gerente
boundary Interfaz
control Controlador
database BD

Gerente -> Interfaz : Abrir Dashboard
activate Interfaz

Interfaz -> Controlador : Solicitar KPIs
activate Controlador

Controlador -> BD : Consultar entregas
activate BD
BD --> Controlador : Datos entregas
deactivate BD

Controlador -> BD : Consultar combustible
activate BD
BD --> Controlador : Datos combustible
deactivate BD

Controlador -> Controlador : Calcular % entregas a tiempo
Controlador -> Controlador : Calcular km recorridos
Controlador -> Controlador : Calcular combustible gastado

Controlador --> Interfaz : KPIs calculados
deactivate Controlador

Interfaz --> Gerente : Mostrar graficos
deactivate Interfaz

@enduml
```

### HU10 - Alertas por Retrasos

```plantuml
@startuml
actor Gerente
boundary Interfaz
control Controlador
participant GPS
participant "Servicio Notificaciones" as NOTIF
database BD

Controlador -> BD : Consultar pedidos activos
activate BD
BD --> Controlador : Lista pedidos
deactivate BD

loop por cada pedido activo
  Controlador -> GPS : Obtener ubicacion actual
  activate GPS
  GPS --> Controlador : Coordenadas
  deactivate GPS

  Controlador -> Controlador : Comparar ETA vs real

  alt desviacion > 15 min
    Controlador -> NOTIF : Enviar alerta
    activate NOTIF
    NOTIF --> Controlador : OK
    deactivate NOTIF

    Controlador --> Interfaz : Generar alerta
    activate Interfaz
    Interfaz --> Gerente : Notificar retraso
    deactivate Interfaz
  else
    Controlador -> Controlador : Continuar monitoreo
  end
end

@enduml
```

## Stack Tecnológico

- Desarrollo: Open source
- Mapas: API de Mapas (Google Maps / OpenStreetMap)
- GPS: Sistema de geolocalización en tiempo real
