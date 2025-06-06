///| Quaternion {w, x, y, z}
pub(all) struct Quaternion {
  mut w : Float
  mut x : Float
  mut y : Float
  mut z : Float
} derive(Eq)

// Show
///|
/// Converts a quaternion to its string representation in the format "Quaternion
/// { w: <w>, x: <x>, y: <y>, z: <z> }".
///
/// Parameters:
///
/// * `quaternion`: The quaternion to be converted to string.
///
/// Returns a string representation of the quaternion.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::to_string" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   inspect!(
///     q.to_string(),
///     content="Quaternion { w: 1.0, x: 2.0, y: 3.0, z: 4.0 }",
///   )
/// }
/// ```
pub fn Quaternion::to_string(self : Quaternion) -> String {
  "Quaternion { w: \{self.w}, x: \{self.x}, y: \{self.y}, z: \{self.z} }"
}

///|
pub impl Show for Quaternion with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
/// Creates a new quaternion with the given components. This is a shorter
/// alternative to using the `Quaternion` constructor directly.
///
/// Parameters:
///
/// * `w` : The scalar (real) component of the quaternion.
/// * `x` : The first vector (imaginary) component of the quaternion.
/// * `y` : The second vector (imaginary) component of the quaternion.
/// * `z` : The third vector (imaginary) component of the quaternion.
///
/// Returns a new `Quaternion` instance with the specified components.
///
/// Example:
///
/// ```moonbit
/// test "q" {
///   let quaternion = q(1.0, 2.0, 3.0, 4.0)
///   inspect!(
///     quaternion.to_string(),
///     content="Quaternion { w: 1.0, x: 2.0, y: 3.0, z: 4.0 }",
///   )
/// }
/// ```
pub fn q(w : Float, x : Float, y : Float, z : Float) -> Quaternion {
  Quaternion::{ w, x, y, z }
}

///|
/// Creates a quaternion from four integer components by converting them to
/// floating-point numbers. Serves as a convenient shortcut when working with
/// integer values.
///
/// Parameters:
///
/// * `w` : The real (scalar) component of the quaternion.
/// * `x` : The first imaginary component (i coefficient).
/// * `y` : The second imaginary component (j coefficient).
/// * `z` : The third imaginary component (k coefficient).
///
/// Returns a new quaternion with the integer components converted to
/// floating-point numbers.
///
/// Example:
///
/// ```moonbit
/// test "qi" {
///   let quaternion = qi(1, 2, 3, 4)
///   inspect!(quaternion, content="Quaternion { w: 1.0, x: 2.0, y: 3.0, z: 4.0 }")
/// }
/// ```
pub fn qi(w : Int, x : Int, y : Int, z : Int) -> Quaternion {
  q(w.to_float(), x.to_float(), y.to_float(), z.to_float())
}

///|
/// Returns an identity quaternion, which is a quaternion with w=1 and x=y=z=0.
/// An identity quaternion represents no rotation in 3D space and acts as a
/// multiplicative identity for quaternion multiplication.
///
/// Returns a quaternion representing the identity rotation.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::id" {
///   let q = Quaternion::id()
///   inspect!(q, content="Quaternion { w: 1.0, x: 0.0, y: 0.0, z: 0.0 }")
///
///   // demonstrate identity property
///   let p = Quaternion::{ w: 2.0, x: 3.0, y: 4.0, z: 5.0 }
///   inspect!(p * q, content=p.to_string())
/// }
/// ```
pub fn Quaternion::id() -> Quaternion {
  Quaternion::{ w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
}

///|
/// Creates a new quaternion with optional components. If any component is not
/// provided, it defaults to 0.0.
///
/// Parameters:
///
/// * `w` : The scalar (real) component of the quaternion. Defaults to 0.0.
/// * `x` : The first vector (imaginary) component of the quaternion. Defaults to
/// 0.0.
/// * `y` : The second vector (imaginary) component of the quaternion. Defaults
/// to 0.0.
/// * `z` : The third vector (imaginary) component of the quaternion. Defaults to
/// 0.0.
///
/// Returns a new `Quaternion` instance with the specified or default components.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::new" {
///   let q1 = Quaternion::new()
///   let q2 = Quaternion::new(w=1.0, x=2.0)
///   inspect!(q1, content="Quaternion { w: 0.0, x: 0.0, y: 0.0, z: 0.0 }")
///   inspect!(q2, content="Quaternion { w: 1.0, x: 2.0, y: 0.0, z: 0.0 }")
/// }
/// ```
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

///|
/// Performs element-wise multiplication of a quaternion with a scalar value,
/// producing a new quaternion.
///
/// Parameters:
///
/// * `self`: The quaternion to be scaled.
/// * `scalar`: A floating-point value to scale the quaternion with.
///
/// Returns a new quaternion where each component (w, x, y, z) is multiplied by
/// the scalar value.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::scale" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   let scaled = q.scale(2.0)
///   inspect!(scaled, content="Quaternion { w: 2.0, x: 4.0, y: 6.0, z: 8.0 }")
/// }
/// ```
pub fn Quaternion::scale(self : Quaternion, t : Float) -> Quaternion {
  Quaternion::{ w: self.w * t, x: self.x * t, y: self.y * t, z: self.z * t }
}

///|
/// Scales a quaternion by multiplying each component with a scalar value
/// in-place.
///
/// Parameters:
///
/// * `self` : The quaternion to be scaled.
/// * `scalar` : The scaling factor to multiply with each component of the
/// quaternion.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::scale_mut" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   q.scale_mut(2.0)
///   inspect!(q, content="Quaternion { w: 2.0, x: 4.0, y: 6.0, z: 8.0 }")
/// }
/// ```
pub fn Quaternion::scale_mut(self : Quaternion, t : Float) -> Unit {
  self.w = self.w * t
  self.x = self.x * t
  self.y = self.y * t
  self.z = self.z * t
}

///|
/// Returns a new quaternion that represents the multiplicative inverse of the
/// input quaternion. The inverse of a quaternion q satisfies q \* q^(-1) =
/// q^(-1) \* q = 1 (identity quaternion).
///
/// Parameters:
///
/// * `quaternion`: The input quaternion to be inverted. Must have non-zero
/// length.
///
/// Returns a new quaternion that is the inverse of the input quaternion.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::inverse" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   let q_inv = q.inverse()
///   inspect!((q * q_inv).roughly_eq(Quaternion::id()), content="true")
/// }
/// ```
pub fn Quaternion::inverse(self : Quaternion) -> Quaternion {
  self.conjugate().scale(1.0.to_float() / self.square_length())
}

///|
/// Mutates the quaternion by computing its inverse (reciprocal).
///
/// For a quaternion q = w + xi + yj + zk, its inverse is q⁻¹ =
/// conjugate(q)/|q|², where |q| is the length of the quaternion.
///
/// Parameters:
///
/// * `self`: The quaternion to be inverted in-place.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::inverse_mut" {
///   let q = Quaternion::{ w: 2.0, x: 0.0, y: 0.0, z: 0.0 }
///   q.inverse_mut()
///   inspect!(q, content="Quaternion { w: 0.5, x: 0.0, y: 0.0, z: 0.0 }")
/// }
/// ```
pub fn Quaternion::inverse_mut(self : Quaternion) -> Unit {
  self.scale_mut(1.0.to_float() / self.square_length())
  self.conjugate_mut()
}

///|
/// Computes the dot product (scalar product) of two quaternions. The dot product
/// is calculated as the sum of the products of corresponding components.
///
/// Parameters:
///
/// * `self` : The first quaternion.
/// * `other` : The second quaternion.
///
/// Returns a float value representing the dot product of the two quaternions.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::dot" {
///   let q1 = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   let q2 = Quaternion::{ w: 2.0, x: 3.0, y: 4.0, z: 5.0 }
///   inspect!(q1.dot(q2), content="40.0")
/// }
/// ```
pub fn Quaternion::dot(self : Quaternion, other : Quaternion) -> Float {
  self.w * other.w + self.x * other.x + self.y * other.y + self.z * other.z
}

///|
/// Returns a new quaternion that is the conjugate of the given quaternion. A
/// quaternion conjugate is formed by negating the vector part (x, y, z
/// components) while keeping the scalar part (w component) unchanged.
///
/// Parameters:
///
/// * `self`: The quaternion to be conjugated.
///
/// Returns a new quaternion that is the conjugate of the input quaternion.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::conjugate" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   inspect!(
///     q.conjugate(),
///     content="Quaternion { w: 1.0, x: -2.0, y: -3.0, z: -4.0 }",
///   )
/// }
/// ```
pub fn Quaternion::conjugate(self : Quaternion) -> Quaternion {
  Quaternion::{ w: self.w, x: -self.x, y: -self.y, z: -self.z }
}

///|
/// Modifies the quaternion in-place by negating its x, y, and z components while
/// keeping the w component unchanged. The conjugate of a quaternion represents
/// the same rotation in the opposite direction.
///
/// Parameters:
///
/// * `self`: The quaternion to be modified. The quaternion will be changed
/// in-place.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::conjugate_mut" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   q.conjugate_mut()
///   inspect!(q, content="Quaternion { w: 1.0, x: -2.0, y: -3.0, z: -4.0 }")
/// }
/// ```
pub fn Quaternion::conjugate_mut(self : Quaternion) -> Unit {
  self.x = -self.x
  self.y = -self.y
  self.z = -self.z
}

///|
/// Computes the squared length (or squared norm) of a quaternion by summing up
/// the squares of its components (w² + x² + y² + z²).
///
/// Parameters:
///
/// * `quaternion`: The quaternion whose squared length is to be computed.
///
/// Returns the squared length of the quaternion as a floating-point number.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::square_length" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 2.0, z: 1.0 }
///   inspect!(q.square_length(), content="10.0")
/// }
/// ```
pub fn Quaternion::square_length(self : Quaternion) -> Float {
  self.w * self.w + self.x * self.x + self.y * self.y + self.z * self.z
}

///|
/// Computes the Euclidean length (magnitude) of a quaternion by taking the
/// square root of the sum of squares of its components.
///
/// Parameters:
///
/// * `quaternion`: The quaternion whose length is to be computed.
///
/// Returns a floating-point number representing the length of the quaternion.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::length" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 2.0, z: 1.0 }
///   inspect!(q.length(), content="3.316624790355399")
/// }
/// ```
pub fn Quaternion::length(self : Quaternion) -> Float {
  self.square_length().sqrt()
}

///|
pub impl Default for Quaternion with default() {
  Quaternion::{ w: 0.0, x: 0.0, y: 0.0, z: 0.0 }
}

///|
pub let max_value : Float = (0x7F7FFFFF).reinterpret_as_float()

///|
/// Determines whether two quaternions are approximately equal by comparing their
/// squared difference with a small epsilon value. This method is necessary
/// because direct floating-point comparisons may not work correctly due to
/// numerical precision issues.
///
/// Parameters:
///
/// * `self`: The first quaternion to compare.
/// * `other`: The second quaternion to compare.
///
/// Returns `true` if the squared distance between the two quaternions is less
/// than the epsilon value (which is the reciprocal of the maximum representable
/// float value), `false` otherwise.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_eq" {
///   let q1 = Quaternion::{ w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
///   let q2 = Quaternion::{ w: 1.0, x: 0.0000000001, y: 0.0, z: 0.0 }
///   inspect!(q1.op_eq(q2), content="true")
/// }
/// ```
pub fn Quaternion::op_eq(self : Quaternion, other : Quaternion) -> Bool {
  (self - other).square_length() < 1.0.to_float() / max_value
}

///|
/// Determines if two quaternions are approximately equal within a specified
/// epsilon value.
///
/// Parameters:
///
/// * `self`: The first quaternion to compare.
/// * `other`: The second quaternion to compare.
/// * `epsilon`: Optional threshold value for comparison. Defaults to
/// 0.00000000001 if not provided.
///
/// Returns true if the squared difference between the two quaternions is less
/// than the epsilon value, false otherwise.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::roughly_eq" {
///   let q1 = Quaternion::{ w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
///   let q2 = Quaternion::{ w: 0.9999999999, x: 0.0, y: 0.0, z: 0.0 }
///   inspect!(q1.roughly_eq(q2), content="true")
/// }
/// ```
pub fn Quaternion::roughly_eq(
  self : Quaternion,
  other : Quaternion,
  epsilon? : Float
) -> Bool {
  (self - other).square_length() < epsilon.or(0.00000000001)
}

///|
/// Adds two quaternions component-wise.
///
/// Parameters:
///
/// * `self` : The first quaternion.
/// * `other` : The second quaternion.
///
/// Returns a new quaternion where each component is the sum of the corresponding
/// components of the input quaternions.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_add" {
///   let q1 = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   let q2 = Quaternion::{ w: 5.0, x: 6.0, y: 7.0, z: 8.0 }
///   inspect!(q1 + q2, content="Quaternion { w: 6.0, x: 8.0, y: 10.0, z: 12.0 }")
/// }
/// ```
pub impl Add for Quaternion with op_add(self : Quaternion, other : Quaternion) -> Quaternion {
  Quaternion::{
    w: self.w + other.w,
    x: self.x + other.x,
    y: self.y + other.y,
    z: self.z + other.z,
  }
}

///|
/// Performs in-place addition of two quaternions by adding their corresponding
/// components.
///
/// Parameters:
///
/// * `self` : The quaternion to be modified.
/// * `other` : The quaternion to be added to `self`.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_add_assign" {
///   let q1 = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   let q2 = Quaternion::{ w: 5.0, x: 6.0, y: 7.0, z: 8.0 }
///   q1.op_add_assign(q2)
///   inspect!(q1, content="Quaternion { w: 6.0, x: 8.0, y: 10.0, z: 12.0 }")
/// }
/// ```
pub fn Quaternion::op_add_assign(self : Quaternion, other : Quaternion) -> Unit {
  self.w = self.w + other.w
  self.x = self.x + other.x
  self.y = self.y + other.y
  self.z = self.z + other.z
}

///|
/// Performs quaternion multiplication (Hamilton product) of two quaternions. The
/// operation is non-commutative, meaning `a * b` is not necessarily equal to `b
/// * a`. This operation can be used to combine rotations represented by
/// quaternions.
///
/// Parameters:
///
/// * `self`: The first quaternion operand.
/// * `other`: The second quaternion operand.
///
/// Returns a new quaternion representing the product of the multiplication.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_mul" {
///   let q1 = Quaternion::{ w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
///   let q2 = Quaternion::{ w: 0.0, x: 1.0, y: 0.0, z: 0.0 }
///   let result = q1 * q2
///   inspect!(result, content="Quaternion { w: 0.0, x: 1.0, y: 0.0, z: 0.0 }")
/// }
/// ```
pub impl Mul for Quaternion with op_mul(self : Quaternion, other : Quaternion) -> Quaternion {
  Quaternion::{
    w: self.w * other.w - self.x * other.x - self.y * other.y - self.z * other.z,
    x: self.w * other.x + self.x * other.w + self.y * other.z - self.z * other.y,
    y: self.w * other.y - self.x * other.z + self.y * other.w + self.z * other.x,
    z: self.w * other.z + self.x * other.y - self.y * other.x + self.z * other.w,
  }
}

///|
/// Performs in-place multiplication of two quaternions using the Hamilton
/// product rule. The result is stored in the first quaternion.
///
/// Parameters:
///
/// * `self`: The quaternion to be modified.
/// * `other`: The quaternion to multiply with.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_mul_assign" {
///   let q1 = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   let q2 = Quaternion::{ w: 2.0, x: -1.0, y: -2.0, z: -3.0 }
///   q1.op_mul_assign(q2)
///   inspect!(
///     q1.to_string(),
///     content="Quaternion { w: 12.0, x: 1.0, y: 0.0, z: -1.0 }",
///   )
/// }
/// ```
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
/// Divides two quaternions by multiplying the first quaternion with the inverse
/// of the second quaternion.
///
/// Parameters:
///
/// * `self` : The dividend quaternion.
/// * `divisor` : The quaternion to divide by.
///
/// Returns a new quaternion representing the quotient of the division operation.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_div" {
///   let a = Quaternion::{ w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
///   let b = Quaternion::{ w: 2.0, x: 0.0, y: 0.0, z: 0.0 }
///   let result = a / b
///   inspect!(result, content="Quaternion { w: 0.5, x: 0.0, y: 0.0, z: 0.0 }")
/// }
/// ```
pub impl Div for Quaternion with op_div(self : Quaternion, b : Quaternion) -> Quaternion {
  self.op_mul(b.inverse())
}

///|
/// Performs element-wise subtraction of two quaternions.
///
/// Parameters:
///
/// * `self`: The minuend quaternion.
/// * `other`: The subtrahend quaternion.
///
/// Returns a new quaternion where each component is the difference of the
/// corresponding components of the input quaternions.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_sub" {
///   let q1 = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   let q2 = Quaternion::{ w: 0.5, x: 1.0, y: 1.5, z: 2.0 }
///   let result = q1 - q2
///   inspect!(result, content="Quaternion { w: 0.5, x: 1.0, y: 1.5, z: 2.0 }")
/// }
/// ```
pub impl Sub for Quaternion with op_sub(self : Quaternion, other : Quaternion) -> Quaternion {
  Quaternion::{
    w: self.w - other.w,
    x: self.x - other.x,
    y: self.y - other.y,
    z: self.z - other.z,
  }
}

///|
/// Subtracts another quaternion from this quaternion in place, modifying the
/// original quaternion.
///
/// Parameters:
///
/// * `self` : The quaternion to be modified.
/// * `other` : The quaternion to subtract from `self`.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_sub_assign" {
///   let q1 = Quaternion::{ w: 2.0, x: 3.0, y: 4.0, z: 5.0 }
///   let q2 = Quaternion::{ w: 1.0, x: 1.0, y: 1.0, z: 1.0 }
///   q1.op_sub_assign(q2)
///   inspect!(q1, content="Quaternion { w: 1.0, x: 2.0, y: 3.0, z: 4.0 }")
/// }
/// ```
pub fn Quaternion::op_sub_assign(self : Quaternion, other : Quaternion) -> Unit {
  self.w = self.w - other.w
  self.x = self.x - other.x
  self.y = self.y - other.y
  self.z = self.z - other.z
}

///|
/// Returns a new quaternion with all components negated. Equivalent to
/// multiplying all components by -1.
///
/// Parameters:
///
/// * `quaternion`: The quaternion to be negated.
///
/// Returns a new quaternion where each component (w, x, y, z) is the negation of
/// the corresponding component in the input quaternion.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::op_neg" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   inspect!(
///     q.op_neg(),
///     content="Quaternion { w: -1.0, x: -2.0, y: -3.0, z: -4.0 }",
///   )
/// }
/// ```
pub fn Quaternion::op_neg(self : Quaternion) -> Quaternion {
  Quaternion::{ w: -self.w, x: -self.x, y: -self.y, z: -self.z }
}

///|
/// Converts a quaternion to an array of floats in the order \[w, x, y, z].
///
/// Parameters:
///
/// * `self`: The quaternion to be converted.
///
/// Returns an array of four floating-point numbers representing the components
/// of the quaternion.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::to_array" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   inspect!(q.to_array(), content="[1.0, 2.0, 3.0, 4.0]")
/// }
/// ```
pub fn Quaternion::to_wxyz(self : Quaternion) -> Array[Float] {
  [self.w, self.x, self.y, self.z]
}

///|
/// Converts a quaternion to an array of floats in the order \[x, y, z, w], which
/// is a common format used in graphics programming.
///
/// Parameters:
///
/// * `self`: The quaternion to be converted.
///
/// Returns an array of four floating-point numbers representing the components
/// of the quaternion in XYZW order.
///
/// Example:
///
/// ```moonbit
/// test "Quaternion::to_xyzw" {
///   let q = Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
///   inspect!(q.to_xyzw(), content="[2.0, 3.0, 4.0, 1.0]")
/// }
/// ```
pub fn Quaternion::to_xyzw(self : Quaternion) -> Array[Float] {
  [self.x, self.y, self.z, self.w]
}

///|
pub(all) type! QuatError String

///|
pub fn from_wxyz(arr : Array[Float]) -> Quaternion!QuatError {
  if arr.length() != 4 {
    raise QuatError("Array must have 4 elements")
  }
  Quaternion::{ w: arr[0], x: arr[1], y: arr[2], z: arr[3] }
}

///| from_xyzw_array
pub fn from_xyzw_array(arr : Array[Float]) -> Quaternion!QuatError {
  if arr.length() != 4 {
    raise QuatError("Array must have 4 elements")
  }
  Quaternion::{ w: arr[3], x: arr[0], y: arr[1], z: arr[2] }
}

///|
pub fn Quaternion::normalize(self : Quaternion) -> Quaternion {
  let len = self.length()
  if len == 0.0 {
    return Quaternion::id()
  }
  self.scale(1.0.to_float() / len)
}

///| normalize mutable
pub fn Quaternion::normalize_mut(self : Quaternion) -> Unit!QuatError {
  let len = self.length()
  if len == 0.0 {
    raise QuatError("Cannot normalize a zero-length quaternion")
  } else {
    self.scale_mut(1.0.to_float() / len)
  }
}
