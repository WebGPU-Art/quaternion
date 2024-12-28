///| Quaternion {w, x, y, z}
pub(all) struct Quaternion {
  mut w : Float
  mut x : Float
  mut y : Float
  mut z : Float
} derive(Eq)

// Show
///|
pub fn Quaternion::to_string(self : Quaternion) -> String {
  "Quaternion { w: \{self.w}, x: \{self.x}, y: \{self.y}, z: \{self.z} }"
}

///|
pub impl Show for Quaternion with output(self, logger) {
  logger.write_string(self.to_string())
}

///| shortcut of create quaternion
pub fn q(w : Float, x : Float, y : Float, z : Float) -> Quaternion {
  Quaternion::{ w, x, y, z }
}

///| shortcut of creating quaternion from integers
pub fn qi(w : Int, x : Int, y : Int, z : Int) -> Quaternion {
  q(w.to_float(), x.to_float(), y.to_float(), z.to_float())
}

///| returns an identity quaternion
pub fn Quaternion::id() -> Quaternion {
  Quaternion::{ w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
}

///| returns a quaternion from xyz
pub fn Quaternion::new(
  w? : Float,
  x? : Float,
  y? : Float,
  z? : Float
) -> Quaternion {
  Quaternion::{
    w: w.or_default(),
    x: x.or_default(),
    y: y.or_default(),
    z: z.or_default(),
  }
}

///| Scales a quaternion (element-wise) by a scalar, returns a new one
pub fn Quaternion::scale(self : Quaternion, t : Float) -> Quaternion {
  Quaternion::{ w: self.w * t, x: self.x * t, y: self.y * t, z: self.z * t }
}

///|
pub fn Quaternion::scale_mut(self : Quaternion, t : Float) -> Unit {
  self.w = self.w * t
  self.x = self.x * t
  self.y = self.y * t
  self.z = self.z * t
}

///| return a inverse of a quaternion
pub fn Quaternion::inverse(self : Quaternion) -> Quaternion {
  self.conjugate().scale(1.0.to_float() / self.square_length())
}

///| mutable version of inverse
pub fn Quaternion::inverse_mut(self : Quaternion) -> Unit {
  self.scale_mut(1.0.to_float() / self.square_length())
  self.conjugate_mut()
}

///| returns dot product of two quaternions
pub fn Quaternion::dot(self : Quaternion, other : Quaternion) -> Float {
  self.w * other.w + self.x * other.x + self.y * other.y + self.z * other.z
}

///| Takes the quaternion conjugate, returns a new one.
pub fn Quaternion::conjugate(self : Quaternion) -> Quaternion {
  Quaternion::{ w: self.w, x: -self.x, y: -self.y, z: -self.z }
}

///| mutable version of conjugate
pub fn Quaternion::conjugate_mut(self : Quaternion) -> Unit {
  self.x = -self.x
  self.y = -self.y
  self.z = -self.z
}

///| Computes the square length of a quaternion.
pub fn Quaternion::square_length(self : Quaternion) -> Float {
  self.w * self.w + self.x * self.x + self.y * self.y + self.z * self.z
}

///| Computes the length of a quaternion.
pub fn Quaternion::length(self : Quaternion) -> Float {
  self.square_length().sqrt()
}

///|
pub impl Default for Quaternion with default() {
  Quaternion::{ w: 0.0, x: 0.0, y: 0.0, z: 0.0 }
}

///|
pub let max_value : Float = (0x7F7FFFFF).reinterpret_as_float()

///| Returns true if the two quaternions very cloase, compared like:
/// ```ignore
/// |a-b|^2 < epsilon
/// ```
pub fn Quaternion::op_eq(self : Quaternion, other : Quaternion) -> Bool {
  (self - other).square_length() < 1.0.to_float() / max_value
}

///| Adds two quaternions, returns a new one.
pub fn Quaternion::op_add(self : Quaternion, other : Quaternion) -> Quaternion {
  Quaternion::{
    w: self.w + other.w,
    x: self.x + other.x,
    y: self.y + other.y,
    z: self.z + other.z,
  }
}

///| Adds two quaternions, returns a new one.
pub fn Quaternion::op_add_assign(self : Quaternion, other : Quaternion) -> Unit {
  self.w = self.w + other.w
  self.x = self.x + other.x
  self.y = self.y + other.y
  self.z = self.z + other.z
}

///| Multiplies two quaternions, returns a new one.
pub fn Quaternion::op_mul(self : Quaternion, other : Quaternion) -> Quaternion {
  Quaternion::{
    w: self.w * other.w - self.x * other.x - self.y * other.y - self.z * other.z,
    x: self.w * other.x + self.x * other.w + self.y * other.z - self.z * other.y,
    y: self.w * other.y - self.x * other.z + self.y * other.w + self.z * other.x,
    z: self.w * other.z + self.x * other.y - self.y * other.x + self.z * other.w,
  }
}

///| Multiplies two quaternions, returns a new one.
pub fn Quaternion::op_mul_assign(self : Quaternion, other : Quaternion) -> Unit {
  let w = self.w * other.w -
    self.x * other.x -
    self.y * other.y -
    self.z * other.z
  let x = self.w * other.x +
    self.x * other.w +
    self.y * other.z -
    self.z * other.y
  let y = self.w * other.y -
    self.x * other.z +
    self.y * other.w +
    self.z * other.x
  let z = self.w * other.z +
    self.x * other.y -
    self.y * other.x +
    self.z * other.w
  self.w = w
  self.x = x
  self.y = y
  self.z = z
}

///|
pub fn Quaternion::op_div(self : Quaternion, b : Quaternion) -> Quaternion {
  self.op_mul(b.inverse())
}

///| substraction of two quaternions, returning new value
pub fn Quaternion::op_sub(self : Quaternion, other : Quaternion) -> Quaternion {
  Quaternion::{
    w: self.w - other.w,
    x: self.x - other.x,
    y: self.y - other.y,
    z: self.z - other.z,
  }
}

///| substraction of two quaternions, returning new value
pub fn Quaternion::op_sub_assign(self : Quaternion, other : Quaternion) -> Unit {
  self.w = self.w - other.w
  self.x = self.x - other.x
  self.y = self.y - other.y
  self.z = self.z - other.z
}

///| negate number
pub fn Quaternion::op_neg(self : Quaternion) -> Quaternion {
  Quaternion::{ w: -self.w, x: -self.x, y: -self.y, z: -self.z }
}

///|
pub fn Quaternion::to_array(self : Quaternion) -> Array[Float] {
  [self.w, self.x, self.y, self.z]
}

///| convert to xyzw, useful for Graphics
pub fn Quaternion::to_xyzw(self : Quaternion) -> Array[Float] {
  [self.x, self.y, self.z, self.w]
}

///|
pub(all) type! QuatError String

///|
pub fn Quaternion::from_array(arr : Array[Float]) -> Quaternion!QuatError {
  if arr.length() != 4 {
    raise QuatError("Array must have 4 elements")
  }
  Quaternion::{ w: arr[0], x: arr[1], y: arr[2], z: arr[3] }
}

///| from_xyzw_array
pub fn Quaternion::from_xyzw_array(arr : Array[Float]) -> Quaternion!QuatError {
  if arr.length() != 4 {
    raise QuatError("Array must have 4 elements")
  }
  Quaternion::{ w: arr[3], x: arr[0], y: arr[1], z: arr[2] }
}

///| Construct a quaternion representing the given euler angle rotations (in radians)
pub fn Quaternion::from_euler_angles(
  x : Float,
  y : Float,
  z : Float
) -> Quaternion {
  let two : Float = 2.0
  let half_x = x / two
  let half_y = y / two
  let half_z = z / two
  let cos_x_2 = @math.cos(half_x.to_double()).to_float()
  let cos_y_2 = @math.cos(half_y.to_double()).to_float()
  let cos_z_2 = @math.cos(half_z.to_double()).to_float()
  let sin_x_2 = @math.sin(half_x.to_double()).to_float()
  let sin_y_2 = @math.sin(half_y.to_double()).to_float()
  let sin_z_2 = @math.sin(half_z.to_double()).to_float()
  Quaternion::{
    w: cos_x_2 * cos_y_2 * cos_z_2 + sin_x_2 * sin_y_2 * sin_z_2,
    x: sin_x_2 * cos_y_2 * cos_z_2 + cos_x_2 * sin_y_2 * sin_z_2,
    y: cos_x_2 * sin_y_2 * cos_z_2 + sin_x_2 * cos_y_2 * sin_z_2,
    z: cos_x_2 * cos_y_2 * sin_z_2 + sin_x_2 * sin_y_2 * cos_z_2,
  }
}
