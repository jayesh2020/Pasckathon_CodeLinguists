import React, { Fragment, useEffect, useState } from "react";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import Spinner from '../components/layout/Spinner';
import { auth, signInWithGoogle } from "../firebase/firebase";

import "./Signin.scss";

const Signin = (props) => {
  const [toggler,setToggler] = useState(false);
  const [user, setUser] = useState({
    email: "",
    password: "",
  });
  useEffect(() => {
    setTimeout(setToggler(true),3000);
  })

  const onChange = (e) => {
    const { name, value } = e.target;

    setUser({ ...user, [name]: value });
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    const { email, password } = user;
    const user1 = await auth.signInWithEmailAndPassword(email, password);
    console.log(user1);
    setUser({
      email: "",
      password: "",
    });
  };
  return (
    <div className="Signin">
      {!toggler && <Spinner />}
      {toggler && <Fragment><h3> Sign in to you application!!!</h3>
      <form noValidate autoComplete="off" onSubmit={onSubmit}>
        <TextField
          label="Email"
          variant="outlined"
          fullWidth
          name="email"
          onChange={onChange}
        />
        <TextField
          label="Password"
          variant="outlined"
          fullWidth
          name="password"
          onChange={onChange}
          type="password"
        />
        <Button type="submit" fullWidth variant="contained" color="primary">
          Sign In
        </Button>
        
      </form>
      </Fragment>
}    </div>
  );
};

export default Signin;
