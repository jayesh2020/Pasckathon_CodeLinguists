import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import {
  MDBContainer,
  MDBBtn,
  MDBModal,
  MDBModalBody,
  MDBModalHeader,
  MDBModalFooter,
  Container,
  Card,
  Row,
  Col
} from 'mdbreact';
import {
  getAppointments,
  setCurrentReport,
  cancelAppointment,
  getReports,
  clearCurrentReport,
  changeProgress,
} from '../../actions/docDashFun';
import Report from '../consult/Report';
const DashboardDoctor = ({
  history,
  auth,
  docDashFunc,
  getAppointments,
  setCurrentReport,
  cancelAppointment,
  changeProgress,
  clearCurrentReport,
  getReports,
}) => {
  useEffect(() => {
    getAppointments(auth.uid);
    getReports(auth.uid);
  }, []);

  const [toggler, setToggler] = useState(false);
  const [consultToggler, setConsultToggler] = useState(false);
  const clickHandler = (appoint) => {
    setCurrentReport({ appoint });
    history.push('/doctor/report');
  };

  const cancelAppoint = (appoint) => {
    cancelAppointment({ appoint });
  };

  const handleInPerson = (report) => {
    if(report.progress == 'a' || report.progress == 'b'){
      changeProgress({report, status: 'd'})
    }
    setConsultToggler(false);
  }

  const viewReportClick = (report) => {
    if (report.progress == 'a') {
      changeProgress({ report,status: 'b' });
    }
    setToggler(true);
  };

  const toggle = () => {
    setToggler(false);
    clearCurrentReport();
  };

  const toggleConsult = () => {
    if (consultToggler === true) setConsultToggler(false);
    else setConsultToggler(true);
  };
  const { appointments, reports, currentReport } = docDashFunc;
  return (
    <div>
      <MDBContainer>
        <div>
          {reports && (
            <div>
              {reports && <h3>Reports</h3>}
                <Row lg={3}>
                {reports.map((report) => (
                  <Col>
                  <div>
                    
                    <img
                      src={report.patientProfilePic}
                      height='30%'
                      width='30%'
                    />
                    <p> Name: {report.patientName}</p>
                    <p> Number: {report.patientNumber}</p>
                    <button
                      className='btn btn-warning text-white'
                      onClick={(e) => {
                        e.preventDefault();
                        setCurrentReport({ report });
                        viewReportClick(report);
                      }}
                    >
                      View Report
                    </button>
                    {(report.progress != 'c' && report.progress != 'd') && <button
                      className='btn btn-warning text-white'
                      onClick={(e) => {
                        e.preventDefault();
                        toggleConsult();
                        setCurrentReport({report});
                      }}
                    >
                      Start Consulting
                    </button>}
                    {(report.progress == 'd') && <h6>Waiting for confirmation of appoinment from patient</h6>}
                    </div>
                  </Col>
                ))}
              </Row>
              
            </div>
          )}
        </div>
        <div>
          {appointments && (
            <div>
              {appointments && <h3>Appointments</h3>}
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
                  <button
                    className='btn btn-warning text-white'
                    onClick={(e) => {
                      e.preventDefault();
                      clickHandler(appoint);
                    }}
                  >
                    Start Appointment
                  </button>
                  <button
                    className='btn btn-warning text-white'
                    onClick={(e) => {
                      e.preventDefault();
                      cancelAppoint(appoint);
                    }}
                  >
                    Cancel Appointment
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
        <MDBModal
          isOpen={toggler}
          toggle={toggle}
          size='lg'
          
        >
          <MDBModalHeader toggle={toggle}>Report</MDBModalHeader>
          <MDBModalBody>
            <Report report={currentReport} />
          </MDBModalBody>
        </MDBModal>
        <MDBModal isOpen={consultToggler} toggle={toggleConsult} centered>
          <MDBModalHeader toggle={toggleConsult}>Consult</MDBModalHeader>
          <MDBModalBody>
            <h3>Consulting Way</h3>
          </MDBModalBody>
          <MDBModalFooter>
            <div style={{ position: 'absolute', left: '0' }}>
              <MDBBtn onClick={(e) => {
                e.preventDefault();
                handleInPerson(currentReport)
              }} color='secondary'>In Person</MDBBtn>
            </div>
            <div style={{ right: '0' }}>
              <MDBBtn color='primary'>Online</MDBBtn>
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
  cancelAppointment: (data) => dispatch(cancelAppointment(data)),
  getReports: (uid) => dispatch(getReports(uid)),
  clearCurrentReport: () => dispatch(clearCurrentReport()),
  changeProgress: (data) => dispatch(changeProgress(data)),
});
export default connect(mapStateToProps, mapDispatchToProps)(DashboardDoctor);
