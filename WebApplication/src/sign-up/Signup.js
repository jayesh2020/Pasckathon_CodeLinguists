import React,{useState, useEffect} from "react";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import { auth, createUserProfileDocument } from '../firebase/firebase';
import "./Signup.scss";
import { connect } from 'react-redux';
import { loadUser,setUser } from '../actions/auth';
import { Redirect } from "react-router-dom";

const Signup = ({history,loadUser,setUser}) => {
  const [newUser,setUSer] = useState({displayName:"",email:"",password:""});

  const {displayName,email,password}=newUser;
  
  const onChange =(e) => {
    const { name, value } = e.target;

    setUSer({ ...newUser,[name]:value });
  }

  const onSubmit = async (e) => {
    e.preventDefault();
    const {user} =  await auth.createUserWithEmailAndPassword(newUser.email,newUser.password);
    const userReference = await createUserProfileDocument(user);
    if(userReference) {
      //loadUser(user.id);
      setUser(userReference);
      //await createUserProfileDocument(user,{ displayName:newUser.displayName });
      history.push('/personalinfo');
      setUSer({displayName:"",email:"",password:""});
    }
  }

 return (
  <div className="Signup">
    <h3> Sign up to you application!!!</h3>
    <form noValidate autoComplete="off" onSubmit={onSubmit}>
    <TextField label="User name" onChange={onChange} name="displayName" variant="outlined" fullWidth value={displayName} />
      <TextField label="Email" onChange={onChange} name="email" type="email" variant="outlined" fullWidth value={email} />
      <TextField label="Password" onChange={onChange} name="password" type="password" variant="outlined" fullWidth value={password} />
      <Button type="submit" fullWidth variant="contained" color="primary">
        Sign Up
      </Button>
    </form>
  </div>
)};
const mapDispatchToProps = (dispatch) => ({
  setUser: (user) => dispatch(setUser(user)),
  loadUser: (id) => dispatch(loadUser(id))
});

export default connect(null,mapDispatchToProps)(Signup);
