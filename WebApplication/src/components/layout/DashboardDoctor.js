import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import { getAppointments } from '../../actions/docDashFun';

const DashboardDoctor = ({ auth, docDashFunc, getAppointments }) => {
  useEffect(() => {
    getAppointments(auth.uid);
  }, []);
  const { appointments } = docDashFunc;
  return (
    <div>
      Dashboard
      {appointments && (
        <div>
          <h3>Appointments</h3>
          {appointments.map((appoint) => (
            <div>
              <img src={appoint.patientProfilePic} height='30%' width='30%' />
              <p> Name: {appoint.patientName}</p>
              <p>Appointment Time: {appoint.appointmentTime}</p>
              <p>Appointment Date: {appoint.diseasePrediction}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

const mapStateToProps = (state) => ({
  auth: state.auth,
  docDashFunc: state.docDashFunc,
});

const mapDispatchToProps = (dispatch) => ({
  getAppointments: (uid) => dispatch(getAppointments(uid)),
});
export default connect(mapStateToProps, mapDispatchToProps)(DashboardDoctor);
