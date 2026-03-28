# ZombiesH - Juego para Godot 4.x

## Descripción
J shooter estilo "ventana" donde el jugador está fijo en el centro y dispara a zombies que vienen de frente.

## Controles
- **Mouse**: Apuntar
- **Click izquierdo**: Disparar ametralladora (balas infinitas)
- **Click derecho**: Lanzar bomba (3 bombas, máximo)
- **R**: Reiniciar juego (cuando termina)

## Sistema de Fases
Cada OLA tiene 2 fases:
1. **Ataque Lento** (1 minuto): Pocos zombies, música tense
2. **Ataque Intenso** (2 minutos): Más zombies, música action

## Sistema de Olas
- 5 olas en total
- Al completar una ola: mensaje épico
- Al completar las 5: **VICTORIA**

## Soldados Muertos
- Aparecen aleatoriamente cada 15-30 segundos
- Pasa el mouse sobre ellos para collect +1 bomba

## Música y Sonido
Para añadir música y efectos de sonido, coloca archivos en:
- `music/music_slow.ogg` - Música ataque lento
- `music/music_intense.ogg` - Música ataque intenso  
- `music/music_epic.ogg` - Música victoria
- `music/music_gameover.ogg` - Música game over
- `sfx/sfx_shoot.ogg` - Sonido disparo
- `sfx/sfx_bomb.ogg` - Sonido explosión
- `sfx/sfx_pickup.ogg` - Sonido collect

## Cómo ejecutar
1. Abre Godot 4.x
2. Importa el proyecto
3. Presiona F5 para ejecutar
