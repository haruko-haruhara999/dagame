// ========== Input ==========
right_key = keyboard_check(vk_right);
left_key = keyboard_check(vk_left);
up_key = keyboard_check(vk_up);
down_key = keyboard_check(vk_down);



// ========== Stun check ==========
if (stunned) {
    sprite_index = Spr_Player_Collect; // stunned or collect sprite
    stun_timer -= 1;

    if (stun_timer <= 0) {
        stunned = false;
        sprite_index = sprite[face]; // return to normal facing sprite
    }
    return; // prevent any input or movement
}

// ========== Movement ==========
xspd = (right_key - left_key) * move_spd;
yspd = (down_key - up_key) * move_spd;

// ========== Collision ==========
if place_meeting(x + xspd, y, Obj_Wall) {
    xspd = 0;
}
if place_meeting(x, y + yspd, Obj_Wall) {
    yspd = 0;
}

x += xspd;
y += yspd;

// ========== Direction / Facing ==========
if (xspd > 0) face = RIGHT;
if (xspd < 0) face = LEFT;
if (xspd == 0) {
    if (yspd > 0) face = DOWN;
    if (yspd < 0) face = UP;
}
if (xspd > 0 && face == LEFT) face = RIGHT;
if (xspd < 0 && face == RIGHT) face = LEFT;
if (yspd > 0 && face == UP) face = DOWN;
if (yspd < 0 && face == DOWN) face = UP;

sprite_index = sprite[face]; // apply correct direction sprite

// ========== Animation ==========
if (xspd == 0 && yspd == 0) {
    image_index = 0;
}

// ========== Hammer Ability ==========
if (has_Obj_Hammer == true) {
    delay -= 1;
    delay = clamp(delay, 0, infinity);

    if (delay == 0 && keyboard_check_pressed(ord("Z"))) {
        thunder_instance = instance_create_layer(x, y, "instances", Obj_Thunder);
        thunder_instance.direction = 90 * face;
    }
}

// ========== Hammer Pickup Logic (Stun Once) ==========

if (has_Obj_Hammer && !hammer_collected) {
    stunned = true;
    stun_timer = stun_duration;
    sprite_index = Spr_Player_Collect;
    hammer_collected = true; // mark that we've already done it
}

// ========== Health Logic ==========
if (keyboard_check_pressed(ord("J")))
{
    if (health > 0)
    {
        health = health - 5;
    }
}
