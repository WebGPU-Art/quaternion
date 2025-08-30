///| Construct a quaternion representing the given euler angle rotations (in radians)
/// Notice: this function is not well tested yet
pub fn Quaternion::from_euler_angles(
  x : Float,
  y : Float,
  z : Float,
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
