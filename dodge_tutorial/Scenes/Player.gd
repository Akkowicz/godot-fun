extends Area2D
signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()
    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
    # Swap animations based on velocity
    if velocity.x != 0:
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = velocity.y > 0
        $AnimatedSprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        $AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = velocity.y > 0
        $AnimatedSprite.flip_h = velocity.x < 0
    

# Player disappears after being hit.
func _on_Player_body_entered(body):
    hide()  
    emit_signal("hit")
    # Set_deffered, because disabling Collision in the middle of collision computation is unsafe
    $CollisionShape2D.set_deferred("disabled", true)

# Reset to starting position
func start(pos):
    position = pos
    show()
    # Enable collision
    $CollisionShape2D.disabled = false
