import React, { useState, useEffect } from 'react';
import './App.scss';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import configureStore from './store/configureStore';
import { Provider } from 'react-redux';
import Signin from './sign-in/SigninPatient';
import Spinner from './components/layout/Spinner';
import 'bootstrap/dist/css/bootstrap.min.css';

import Signup from './sign-up/Signup';
import Userinfo from './user-info/Userinfo';
import PrivateRouter from './routers/PrivateRoute';
import PublicRouter from './routers/PublicRoute';
import ImageTest from './components/layout/Test';
import { auth, createUserProfileDocument } from './firebase/firebase';
import DashboardPatient from './components/layout/DashboardPatient';
import { loadUser, setUser } from './actions/auth';
import PersonalInfo from './components/info/PersonalInfo';
import DoctorsInfo from './components/info/DoctorsInfo';
import PatientsInfo from './components/info/PatientsInfo';
import Navbar from './shared/Navbar';
import DoctorSearch from './components/consult/DoctorSearch';
import DoctorConsult from './components/consult/DoctorConsult';
import DashboardDoctor from './components/layout/DashboardDoctor';
const store = configureStore();
//const history = createBrowserHistory();
const App = () => {
  const [currentUser, setCurrentUser] = useState(null);
  const [isAuthenticated, setAuth] = useState(false);

  useEffect(() => {
    auth.onAuthStateChanged(async (userAuth) => {
      if (userAuth) {
        //console.log(userAuth);
        console.log(userAuth);
        //loadUser(userAuth.uid);

        const user = await createUserProfileDocument(userAuth);
        //setUser(user);
        setCurrentUser(user);
        console.log(currentUser);
      }
      setCurrentUser(userAuth);
    });
  }, []);

  /*
useEffect(() => {
  auth.onAuthStateChanged( async userAuth => {
    if(userAuth) {
      //console.log(userAuth);
      console.log(userAuth.uid);
      loadUser(userAuth);
      const user = await createUserProfileDocument(userAuth);
        user.onSnapshot((snapshot) => {
          setCurrentUser({
              id: snapshot.id,
              ...snapshot.data(),
          });
        });
    }
  })
},[]);
*/
  return (
    <Provider store={store}>
      <div className='App'>
        <Router>
          <Navbar />
          <Switch>
            <PublicRouter exact path='/' component={Signup} />
            <PublicRouter path='/login' component={Signin} />
            <PrivateRouter path='/dashboard' component={DashboardPatient} />
            <PrivateRouter path='/doctor/dashboard' component={DashboardDoctor} />
            <PrivateRouter path='/imagetest' component={ImageTest} />
            <PrivateRouter path='/personalinfo' component={PersonalInfo} />
            <PrivateRouter path='/patientsinfo' component={PatientsInfo} />
            <PrivateRouter path='/doctorsinfo' component={DoctorsInfo} />
            <PrivateRouter path='/doctorsearch' component={DoctorSearch} />
            <PrivateRouter
              path='/doctor/consult/:id'
              component={DoctorConsult}
            />
          </Switch>
        </Router>
      </div>
    </Provider>
  );
};
auth.onAuthStateChanged(async (user) => {
  if (user) {
    store.dispatch(loadUser(user.uid));
    console.log(user);
    const userRefere = await createUserProfileDocument(user);
    console.log(userRefere);
    store.dispatch(setUser(userRefere));
  }
});

export default App;
