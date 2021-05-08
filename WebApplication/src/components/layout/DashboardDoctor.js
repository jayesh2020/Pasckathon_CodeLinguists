import React, { useEffect, useState,Fragment } from 'react';
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
  getHistory,
  setCurrentReport,
  setCurrentAppReport,
  clearCurrentAppReport,
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
  getHistory,
  getAppointments,
  setCurrentReport,
  setCurrentAppReport,
  clearCurrentAppReport,
  cancelAppointment,
  changeProgress,
  clearCurrentReport,
  getReports,
}) => {
  const { appointments, reports, currentReport } = docDashFunc;

  useEffect(() => {
    getAppointments(auth.uid);
    getReports(auth.uid);
  }, []);

  useEffect(() => {
    console.log("Updating");
  },[appointments,reports]);

  const [toggler, setToggler] = useState(false);
  const [consultToggler, setConsultToggler] = useState(false);
  const clickHandler = (appoint) => {
    console.log(appoint);
    setCurrentAppReport({ appoint });
    history.push('/doctor/onlineconsult');
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
    getHistory({report});
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
  const handleOnline = (e) => {
    e.preventDefault();
  };

  return (
    <div>
      <MDBContainer>
        <div>
          {reports && (
            <div>
              {reports && <h3>Reports</h3>}
              {reports.length == 0 && <p>No pending reports to review</p>}
                <Row lg={3}>
                {reports.map((report) => (
                  <Fragment>
                  {(report.progress!='c' && report.progress!='f') && <Col>
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
                  </Col>}
                  </Fragment>
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
                <Fragment>
                {appoint.progress != 'f' && <div>
                  <img
                    src={appoint.patientProfilePic}
                    height='30%'
                    width='30%'
                  />
                  <p> Name: {appoint.patientName}</p>
                  <p>Appointment Time: {appoint.time}</p>
                  <p>Appointment Date: {appoint.date}</p>
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
                </div>}
                </Fragment>
              ))}
            </div>
          )}
        </div>
        <div>
          {reports && (
            <div>
              {reports && <h3>Verified Reports</h3>}
              {reports.length == 0 && <p>No pending reports to review</p>}
                <Row lg={3}>
                {reports.map((report) => (
                  <Fragment>
                  {(report.progress=='c' || report.progress=='f') && <Col>
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
                    {report.progress == 'c' && <p>Patient Consulted online</p>}
                    {report.progress == 'f' && <p>Patient Consulted in person</p>}
                    </div>
                  </Col>}
                  </Fragment>
                ))}
              </Row>
              
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
              <MDBBtn color='primary' onClick={e => {
                e.preventDefault();
                history.push('/doctor/onlineconsult');
              }}>
                Online
              </MDBBtn>
            </div>
          </MDBModalFooter>
        </MDBModal>
      </MDBContainer>
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
  setCurrentAppReport: (data) => dispatch(setCurrentAppReport(data)),
  cancelAppointment: (data) => dispatch(cancelAppointment(data)),
  getReports: (uid) => dispatch(getReports(uid)),
  clearCurrentReport: () => dispatch(clearCurrentReport()),
  clearCurrentAppReport: () => dispatch(clearCurrentAppReport()),
  changeProgress: (data) => dispatch(changeProgress(data)),
  getHistory: (data) => dispatch(getHistory(data)),
});
export default connect(mapStateToProps, mapDispatchToProps)(DashboardDoctor);
