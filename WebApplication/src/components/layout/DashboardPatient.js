import React, { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { getAppointments, getTests } from '../../actions/dashboardFunc';
import { connect } from 'react-redux';
import Report from '../consult/Report';
import { Card,Container,Row,Col,Carousel,CarouselItem } from 'react-bootstrap';

const DashboardPatient = ({ auth, dashFunc, getTests, getAppointments }) => {
  useEffect(() => {
    getAppointments(auth.uid);
    getTests(auth.uid);
  }, []);
  const { appointments, tests } = dashFunc;
  return (
    <div>
    <div>
    <Carousel style={{maxHeight:"500px"}}>
      <Carousel.Item>
        <img
        style={{maxHeight:400}}
          className="d-block w-100"
          src="/skincare1.jpg"
          alt="First slide"
        />
        <Carousel.Caption>
          <h3>First slide label</h3>
          <p>Nulla vitae elit libero, a pharetra augue mollis interdum.</p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        <img
        style={{maxHeight:400}}
          className="d-block w-100"
          src="/skincare2.jpg"
          alt="Third slide"
        />
    
        <Carousel.Caption>
          <h3>Second slide label</h3>
          <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        <img
        style={{maxHeight:400}}
          className="d-block w-100"
          src="/skincare3.jpg"
          alt="Third slide"
        />
    
        <Carousel.Caption>
          <h3>Third slide label</h3>
          <p>Praesent commodo cursus magna, vel scelerisque nisl consectetur.</p>
        </Carousel.Caption>
      </Carousel.Item>
    </Carousel>
    </div>
      Dashboard
      <Link to='/imagetest'>Test</Link>
      <Link to='/doctorsearch'>Search Doctor</Link>
      <div>
      </div>
      {appointments && (
        <div>
          {appointments && <h3>Appointments</h3>}
          <Container>
          <Row lg={3}>
          {appointments.map((appoint) => (
            <Col>
            <div>
              <Card style={{ width: '18rem' }}>
                <Card.Img variant="top" src={appoint.doctorProfilePic} style={{maxHeight:"400px", height:"200px", maxWidth:"200px", width:"200px", display:"block"}} />
                <Card.Body>
                  <Card.Title>Doctor Name: {appoint.doctorName}</Card.Title>
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
      {tests && (
        <div>
          <h3>Tests</h3>
          <Container>
          <Row lg={3}>
          {tests && tests.map((test) => (
            <Col>
            <div>
            <Card style={{ width: '18rem' }}>
                <Card.Img variant="top" src={test.fireBaseUrl} style={{maxHeight:"400px",paddingBottom:"10px", marginTop:"20px", height:"200px", width:"100%", display:"block"}} />
                <Card.Body>
                  <Card.Title>Disease Name: {test.disease_name}</Card.Title>
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
