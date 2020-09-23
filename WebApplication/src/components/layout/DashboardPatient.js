import React, { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { getAppointments, getTests } from '../../actions/dashboardFunc';
import { connect } from 'react-redux';
import Report from '../consult/Report';

const DashboardPatient = ({ auth, dashFunc, getTests, getAppointments }) => {
  useEffect(() => {
    getAppointments(auth.uid);
    getTests(auth.uid);
  }, []);
  const { appointments, tests } = dashFunc;
  return (
    <div>
      <Report />
      Dashboard
      <Link to='/imagetest'>Test</Link>
      <Link to='/doctorsearch'>Search Doctor</Link>
      <Link to='/doctor/dashboard'>Doctor Dashboard</Link>
      {appointments && (
        <div>
          <h3>Appointments</h3>
          {appointments.map((appoint) => (
            <div>
              <p>Doctor Name: {appoint.doctorName}</p>
              <p>Appointment Time: {appoint.time}</p>
              <p>Appointment Date: {appoint.date}</p>
            </div>
          ))}
        </div>
      )}
      {tests && (
        <div>
          <h3>Tests</h3>
          {tests.map((test) => (
            <div>
              <p>Disease Name: {test.disease_name}</p>
              <p>Description: {test.description}</p>
              <img src={test.fireBaseUrl} height='30%' width='30%' />
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

const mapStateToProps = (state) => ({
  auth: state.auth,
  dashFunc: state.dashFunc,
});

const mapDispatchToProps = (dispatch) => ({
  getAppointments: (uid) => dispatch(getAppointments(uid)),
  getTests: (uid) => dispatch(getTests(uid)),
});
export default connect(mapStateToProps, mapDispatchToProps)(DashboardPatient);
