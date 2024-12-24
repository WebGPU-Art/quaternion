test "q" {
  let q1 = @lib.q(0.0, 0.0, 0.0, 0.0)
  inspect!(q1, content="Quaternion { w: 0, x: 0, y: 0, z: 0 }")
}

test "q/nan" {
  let q1 = @lib.q(@float.not_a_number, 0.0, 0.0, 0.0)
  inspect!(
    q1,
    content="Quaternion { w: \{@double.not_a_number.to_float()}, x: 0, y: 0, z: 0 }",
  )
}

test "Quaternion::new/default_arguments" {
  let q = @lib.Quaternion::new()
  inspect!(q.w, content="0")
  inspect!(q.x, content="0")
  inspect!(q.y, content="0")
  inspect!(q.z, content="0")
}

test "Quaternion::new/partial_defaults" {
  let q = @lib.Quaternion::new(w=1.0.to_float())
  inspect!(q.w, content="1")
  inspect!(q.x, content="0")
  inspect!(q.y, content="0")
  inspect!(q.z, content="0")
}

test "Quaternion::new/all_arguments" {
  let q = @lib.Quaternion::new(
    w=1.0.to_float(),
    x=2.0.to_float(),
    y=3.0.to_float(),
    z=4.0.to_float(),
  )
  inspect!(q.w, content="1")
  inspect!(q.x, content="2")
  inspect!(q.y, content="3")
  inspect!(q.z, content="4")
}

test "Quaternion::scale/large_scalar" {
  let q = @lib.Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
  let t = 1.0e+10.to_float() // Use Float literal
  let result = q.scale(t)
  inspect!(
    result,
    content="Quaternion { w: 10000000000, x: 20000000000, y: 30000001024, z: 40000000000 }", // why 1024?
  )
}

test "Quaternion::inverse/identity" {
  let q = @lib.Quaternion::id()
  inspect!(q.inverse(), content="Quaternion { w: 1, x: 0, y: 0, z: 0 }")
}

test "Quaternion::inverse/zero" {
  let q = @lib.Quaternion::{ w: 0.0, x: 0.0, y: 0.0, z: 0.0 }
  inspect!(q.inverse(), content="Quaternion { w: NaN, x: NaN, y: NaN, z: NaN }")
}

test "Quaternion::inverse/random" {
  let q = @lib.Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
  inspect!(
    q.inverse(),
    content="Quaternion { w: 0.03333333507180214, x: -0.06666667014360428, y: -0.10000000894069672, z: -0.13333334028720856 }",
  )
  inspect!(
    q.inverse().inverse(),
    content="Quaternion { w: 0.9999998807907104, x: 1.999999761581421, y: 2.999999761581421, z: 3.999999523162842 }",
  )

  // another random quaternion
  let q2 = @lib.Quaternion::{ w: 0.5, x: 0.5, y: 2.5, z: 0.5 }
  inspect!(
    q2.inverse(),
    content="Quaternion { w: 0.0714285746216774, x: -0.0714285746216774, y: -0.3571428656578064, z: -0.0714285746216774 }",
  )
  inspect!(
    q2.inverse().inverse(),
    content="Quaternion { w: 0.5000000596046448, x: 0.5000000596046448, y: 2.500000238418579, z: 0.5000000596046448 }",
  )
}

test "Quaternion::inverse/general" {
  let q = @lib.Quaternion::{ w: 1.0, x: 2.0, y: 3.0, z: 4.0 }
  inspect!(
    q.inverse(),
    content="Quaternion { w: 0.03333333507180214, x: -0.06666667014360428, y: -0.10000000894069672, z: -0.13333334028720856 }",
  )
}

test "Quaternion::dot/basic" {
  let q1 = @lib.q(1.0, 2.0, 3.0, 4.0)
  let q2 = @lib.q(5.0, 6.0, 7.0, 8.0)
  // dot product should be: 1*5 + 2*6 + 3*7 + 4*8 = 70
  inspect!(q1.dot(q2), content="70")
}

test "Quaternion::dot/identity" {
  let q1 = @lib.q(2.0, 3.0, 4.0, 5.0)
  let id = @lib.Quaternion::id()
  // dot with identity should give: 2*1 + 3*0 + 4*0 + 5*0 = 2
  inspect!(q1.dot(id), content="2")
}

test "Quaternion::dot/zero" {
  let q1 = @lib.q(1.0, 2.0, 3.0, 4.0)
  let zero = @lib.Quaternion::default()
  // dot with zero should give 0
  inspect!(q1.dot(zero), content="0")
}

test "Quaternion::op_eq" {
  // identical quaternions should be equal
  let q1 = @lib.q(1.0, 2.0, 3.0, 4.0)
  inspect!(q1 == q1, content="true")

  // very close quaternions should be equal
  let q2 = @lib.q(1.0, 2.0, 3.0, 4.0)
  let q3 = @lib.q(1.0000000001, 2.0, 3.0, 4.0)
  inspect!(q2 == q3, content="true")
}

test "Quaternion::op_eq/zero" {
  // zero quaternions should be equal
  let zero1 = @lib.q(0.0, 0.0, 0.0, 0.0)
  let zero2 = @lib.q(0.0, 0.0, 0.0, 0.0)
  inspect!(zero1 == zero2, content="true")
}

test "Quaternion::op_eq/distinct" {
  // clearly different quaternions should not be equal
  let q1 = @lib.q(1.0, 0.0, 0.0, 0.0)
  let q2 = @lib.q(0.0, 1.0, 0.0, 0.0)
  inspect!(q1 == q2, content="false")
}

test "Quaternion::length/basic" {
  let q1 = @lib.Quaternion::{ w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
  let q2 = @lib.Quaternion::{ w: 0.0, x: 1.0, y: 0.0, z: 0.0 }
  let q3 = @lib.Quaternion::{ w: 1.0, x: 1.0, y: 1.0, z: 1.0 }
  inspect!(q1.length(), content="1")
  inspect!(q2.length(), content="1")
  inspect!(q3.length(), content="2")
}

test "Quaternion::length/zero" {
  let q = @lib.Quaternion::{ w: 0.0, x: 0.0, y: 0.0, z: 0.0 }
  inspect!(q.length(), content="0")
}

test "Quaternion::length/negative" {
  let q = @lib.Quaternion::{ w: -1.0, x: -1.0, y: -1.0, z: -1.0 }
  inspect!(q.length(), content="2")
}

test "Quaternion::conjugate/basic" {
  let q = @lib.Quaternion::{ w: 2.0, x: 3.0, y: -4.0, z: 5.0 }
  let result = q.conjugate()
  inspect!(result, content="Quaternion { w: 2, x: -3, y: 4, z: -5 }")
}

test "Quaternion::conjugate/identity" {
  let q = @lib.Quaternion::id()
  let result = q.conjugate()
  inspect!(result, content="Quaternion { w: 1, x: 0, y: 0, z: 0 }")
}

test "Quaternion::conjugate/zero" {
  let q = @lib.Quaternion::default()
  let result = q.conjugate()
  inspect!(result, content="Quaternion { w: 0, x: 0, y: 0, z: 0 }")
}

test "Quaternion::op_add/basic" {
  let q1 = @lib.q(1.0, 2.0, 3.0, 4.0)
  let q2 = @lib.q(5.0, 6.0, 7.0, 8.0)
  let result = q1 + q2
  inspect!(result, content="Quaternion { w: 6, x: 8, y: 10, z: 12 }")
}

test "Quaternion::op_add/identity" {
  let q1 = @lib.q(1.0, 2.0, 3.0, 4.0)
  let zero = @lib.q(0.0, 0.0, 0.0, 0.0)
  let result = q1 + zero
  inspect!(result, content="Quaternion { w: 1, x: 2, y: 3, z: 4 }")
}

test "Quaternion::op_add/large_values" {
  let large = @float.max_value
  let q1 = @lib.q(large, large, large, large)
  let q2 = @lib.q(large, large, large, large)
  let result = q1 + q2
  inspect!(
    result,
    content="Quaternion { w: Infinity, x: Infinity, y: Infinity, z: Infinity }",
  )
}

test "Quaternion::op_mul/basic" {
  let q1 = @lib.qi(1, 2, 3, 4)
  let q2 = @lib.qi(2, 3, 4, 5)
  let result = q1 * q2
  // mathematical result from manual calculation
  inspect!(result, content="Quaternion { w: -36, x: 6, y: 12, z: 12 }")
}

test "Quaternion::op_mul/identity" {
  let id = @lib.Quaternion::id()
  let q = @lib.qi(1, 2, 3, 4)
  let result = q * id
  // multiplication with identity should return the same quaternion
  inspect!(result, content="Quaternion { w: 1, x: 2, y: 3, z: 4 }")
}

test "Quaternion::op_mul/zero" {
  let zero = @lib.Quaternion::default()
  let q = @lib.qi(1, 2, 3, 4)
  let result = q * zero
  // multiplication with zero should return zero
  inspect!(result, content="Quaternion { w: 0, x: 0, y: 0, z: 0 }")
}

test "Quaternion::op_div/basic" {
  let a = @lib.qi(1, 2, 3, 4)
  let b = @lib.qi(2, 1, 0, 1)
  let result = a / b
  // result should be close to quaternion {w: 1.0, x: 1.6, y: 1.2, z: 1.4}
  inspect!(
    result,
    content="Quaternion { w: 1.3333333730697632, x: 0, y: 0.6666666865348816, z: 1.6666667461395264 }",
  )
  inspect!(result * b, content="Quaternion { w: 1, x: 2, y: 3, z: 4 }")
}
