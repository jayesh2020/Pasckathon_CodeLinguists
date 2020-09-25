import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import {
  MDBContainer,
  MDBBtn,
  MDBModal,
  MDBModalBody,
  MDBModalHeader,
  MDBModalFooter,
} from 'mdbreact';
import { getAppointments,setCurrentReport,cancelAppointment } from '../../actions/docDashFun';
const DashboardDoctor = ({ history,auth, docDashFunc, getAppointments,setCurrentReport,cancelAppointment }) => {
  useEffect(() => {
    getAppointments(auth.uid);
  }, []);

  const clickHandler = (appoint) => {
    setCurrentReport({appoint});
    history.push('/doctor/report');
  }

  const cancelAppoint = (appoint) => {
    cancelAppointment({appoint});
  }
  const { appointments } = docDashFunc;
  return (
    <div>
      <MDBContainer>
        <MDBModal isOpen={true} centered>
          <MDBModalHeader>Patients Report</MDBModalHeader>
          <MDBModalBody>
            <div>
              {appointments && (
                <div>
                  <h3>Appointments</h3>
                  {appointments.map((appoint) => (
                    <div>
                      <img
                        src={appoint.patientProfilePic}
                        height='30%'
                        width='30%'
                      />
                      <p> Name: {appoint.patientName}</p>
                      <p>Appointment Time: {appoint.appointmentTime}</p>
                      <p>Appointment Date: {appoint.diseasePrediction}</p>
                      <button className="btn btn-warning text-white" onClick={(e) => {
                        e.preventDefault();
                        clickHandler(appoint);
                      }}>Start Appointment</button>
                      <button className="btn btn-warning text-white" onClick={(e) => {
                        e.preventDefault();
                        cancelAppoint(appoint);}}
                        >
                          Cancel Appointment
                      </button>
                  </div>
                  ))}
                </div>
              )}

            </div>
          </MDBModalBody>
          <MDBModalFooter>
            <div style={{ position: 'absolute', left: '0' }}>
              <MDBBtn color='secondary'>In Person Diagnosis</MDBBtn>
            </div>
            <div style={{ right: '0' }}>
              <MDBBtn color='primary'>Online Diagnosis</MDBBtn>
            </div>
          </MDBModalFooter>
        </MDBModal>
      </MDBContainer>
      <Link to='/doctorsinfo'>doctorsinfo</Link>
    </div>
  );
};

const mapStateToProps = (state) => ({
  auth: state.auth,
  docDashFunc: state.docDashFunc,
});

const mapDispatchToProps = (dispatch) => ({
  getAppointments: (uid) => dispatch(getAppointments(uid)),
  setCurrentReport: (data) => dispatch(setCurrentReport(data)),
  cancelAppointment: (data) => dispatch(cancelAppointment(data))
});
export default connect(mapStateToProps, mapDispatchToProps)(DashboardDoctor);
