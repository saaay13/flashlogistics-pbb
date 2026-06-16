# Diagrama de Casos de Uso - FlashLogistics DSS

## Actor: Gerente

```
[Gerente] --> (Optimizar rutas)
[Gerente] --> (Ver costo estimado de ruta)
[Gerente] --> (Ver KPIs en dashboard)
[Gerente] --> (Generar reportes semanales)
[Gerente] --> (Ver ubicación de camiones)
[Gerente] --> (Recibir alerta de pedido retrasado)

(Optimizar rutas) ..> (Consultar datos de mapas) : <<include>>
(Ver costo estimado de ruta) ..> (Optimizar rutas) : <<extend>>
(Generar reportes semanales) ..> (Ver KPIs en dashboard) : <<extend>>
(Ver ubicación de camiones) ..> (Obtener coordenadas GPS) : <<include>>
(Recibir alerta de pedido retrasado) ..> (Ver ubicación de camiones) : <<extend>>
(Recibir alerta de pedido retrasado) ..> (Enviar notificación) : <<include>>

[API de Mapas] --> (Consultar datos de mapas)
[Sistema GPS] --> (Obtener coordenadas GPS)
[Servicio de Notificaciones] --> (Enviar notificación)
```

## Actor: Despachador

```
[Despachador] --> (Registrar pedidos)
[Despachador] --> (Ver ubicación de camiones)

(Ver ubicación de camiones) ..> (Obtener coordenadas GPS) : <<include>>

[Sistema GPS] --> (Obtener coordenadas GPS)
```

## Actor: Administrador

```
[Administrador] --> (Registrar conductores)
[Administrador] --> (Registrar vehículos)
```

## Actor: Conductor

```
[Conductor] --> (Ver ruta asignada)
[Conductor] --> (Marcar pedido como entregado)

(Marcar pedido como entregado) ..> (Ver ruta asignada) : <<extend>>
```

## Actor: Cliente

```
[Cliente] --> (Rastrear pedido en vivo)
[Cliente] --> (Recibir notificación de pedido cercano)

(Rastrear pedido en vivo) ..> (Obtener coordenadas GPS) : <<include>>
(Recibir notificación de pedido cercano) ..> (Enviar notificación) : <<include>>

[Sistema GPS] --> (Obtener coordenadas GPS)
[Servicio de Notificaciones] --> (Enviar notificación)
```

## Actores del Sistema

| Actor | Tipo | Descripción |
|-------|------|-------------|
| Gerente | Humano | Supervisa operaciones, toma decisiones estratégicas |
| Despachador | Humano | Gestiona pedidos y monitorea flota |
| Administrador | Humano | Registra conductores y vehículos |
| Conductor | Humano | Ejecuta rutas de reparto vía app móvil |
| Cliente | Humano | Rastrea pedidos y recibe notificaciones |
| API de Mapas | Sistema externo | Provee datos de tráfico y distancias |
| Sistema GPS | Sistema externo | Provee coordenadas en tiempo real |
| Servicio de Notificaciones | Sistema externo | Envía SMS y correos |

## Leyenda

- `-->` : Asociación (actor iniciador)
- `..>` : Relación entre casos de uso
- `<<include>>` : El caso base siempre incluye al otro
- `<<extend>>` : El caso extendido es opcional
- `[Actor]` : Actor humano o sistema externo
- `(Caso de Uso)` : Funcionalidad del sistema
