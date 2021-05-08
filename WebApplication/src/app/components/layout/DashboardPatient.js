import React, { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { getAppointments, getTests,getReports,setCurrentReport } from '../../actions/dashboardFunc';
import { connect } from 'react-redux';
import Report from '../consult/Report';
import {
  Card,
  Container,
  Row,
  Col,
  Carousel,
  CarouselItem,
} from 'react-bootstrap';

const DashboardPatient = ({ auth, dashFunc, getTests, getAppointments,getReports,history, setCurrentReport }) => {
  useEffect(() => {
    getAppointments(auth.uid);
    getTests(auth.uid);
    getReports(auth.uid);
  }, []);
  const { appointments, tests,reports } = dashFunc;
  return (
    <div>
      <div>
        <Carousel style={{ maxHeight: '500px' }}>
          <Carousel.Item>
            <img
              style={{ maxHeight: 400 }}
              className='d-block w-100'
              src='/skincare1.jpg'
              alt='First slide'
            />
            <Carousel.Caption>
              <h3>First slide label</h3>
              <p>Nulla vitae elit libero, a pharetra augue mollis interdum.</p>
            </Carousel.Caption>
          </Carousel.Item>
          <Carousel.Item>
            <img
              style={{ maxHeight: 400 }}
              className='d-block w-100'
              src='/skincare2.jpg'
              alt='Third slide'
            />

            <Carousel.Caption>
              <h3>Second slide label</h3>
              <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
            </Carousel.Caption>
          </Carousel.Item>
          <Carousel.Item>
            <img
              style={{ maxHeight: 400 }}
              className='d-block w-100'
              src='/skincare3.jpg'
              alt='Third slide'
            />

            <Carousel.Caption>
              <h3>Third slide label</h3>
              <p>
                Praesent commodo cursus magna, vel scelerisque nisl consectetur.
              </p>
            </Carousel.Caption>
          </Carousel.Item>
        </Carousel>
      </div>
      Dashboard
      <Link to='/imagetest'>Test</Link>
      <Link to='/doctorsearch'>Search Doctor</Link>
      <div></div>
      {appointments && (
        <div>
          {appointments && <h3>Appointments</h3>}
          <Container>
            <Row lg={3}>
              {appointments.map((appoint) => (
                <Col>
                  <div>
                    <Card style={{ width: '18rem' }}>
                      <Card.Img
                        variant='top'
                        src={appoint.doctorUrl}
                        style={{
                          maxHeight: '400px',
                          height: '200px',
                          maxWidth: '200px',
                          width: '200px',
                          display: 'block',
                        }}
                      />
                      <Card.Body>
                        <Card.Title>
                          Doctor Name: {appoint.doctorName}
                        </Card.Title>
                        <Card.Text>
                          <p>Appointment Time: {appoint.time}</p>
                          <p>Appointment Date: {appoint.date}</p>
                        </Card.Text>
                      </Card.Body>
                    </Card>
                  </div>
                </Col>
              ))}
            </Row>
          </Container>
        </div>
      )}
      {reports && (
        <div>
          {reports && <h3>Progress</h3>}
          <Container>
            <Row lg={3}>
              {reports.map((report) => (
                <Col>
                  <div>
                    <Card style={{ width: '20rem' }}>
                      <Card.Img
                        variant='top'
                        src={report.doctorUrl}
                        style={{
                          maxHeight: '400px',
                          height: '200px',
                          maxWidth: '200px',
                          width: '200px',
                          display: 'block',
                        }}
                      />
                      <Card.Body>
                        <Card.Title>
                        
                          <h4>Status</h4>
                          <ul>
                            <li>
                              <p>Report sent to doctor <i className="fa fa-check-circle"></i></p>
                            </li>
                            {(report.progress=='b'||report.progress=='c'||report.progress=='d'||report.progress=='e')&&<li>
                              <p>Checked by doctor <i className="fa fa-check-circle"></i></p>
                            </li>}
                            {report.progress == 'c' && <li>
                              <p>Online Consult</p><i className="fa fa-check-circle"></i>
                            </li>}
                            {(report.progress == 'd') && <li>
                              <p>In person consultation <i className="fa fa-check-circle"></i></p>
                              <button onClick={e =>{
                                e.preventDefault();
                                setCurrentReport({report});
                                history.push(`/doctor/book/${report.doctorId}`);
                              }} className="btn btn-warning">Book appointment</button>
                            </li>}
                            {report.progress=='e' && <li>
                              <p>Appointment booked <i className="fa fa-check-circle"></i></p>
                            </li>}
                          </ul>
                        </Card.Title>
                        <Card.Text>
                          
                        </Card.Text>
                      </Card.Body>
                    </Card>
                  </div>
                </Col>
              ))}
            </Row>
          </Container>
        </div>
      )}
      {tests && (
        <div>
          <h3>Tests</h3>
          <Container>
            <Row lg={3}>
              {tests &&
                tests.map((test) => (
                  <Col>
                    <div>
                      <Card style={{ width: '18rem' }}>
                        <Card.Img
                          variant='top'
                          src={test.fireBaseUrl}
                          style={{
                            maxHeight: '400px',
                            paddingBottom: '10px',
                            marginTop: '20px',
                            height: '200px',
                            width: '100%',
                            display: 'block',
                          }}
                        />
                        <Card.Body>
                          <Card.Title>
                            Disease Name: {test.disease_name}
                          </Card.Title>
                          <Card.Text>
                            <p>Description: {test.description}</p>
                          </Card.Text>
                        </Card.Body>
                      </Card>
                    </div>
                  </Col>
                ))}
            </Row>
          </Container>
        </div>
      )}
      <Link to='/patientsinfo'>patientsinfo</Link>
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
  getReports: (uid) => dispatch(getReports(uid)),
  setCurrentReport: (data) => dispatch(setCurrentReport(data))
});
export default connect(mapStateToProps, mapDispatchToProps)(DashboardPatient);
