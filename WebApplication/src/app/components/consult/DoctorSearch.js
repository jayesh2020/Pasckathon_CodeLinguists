import React,{ useState,useEffect } from 'react'
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { getDoctors } from '../../actions/doctorSearch';
import { Link } from 'react-router-dom';
import { Card,Button,Col,Row,Container } from 'react-bootstrap';

const DoctorSearch = ({ auth, doctorSearch, getDoctors }) => {
    useEffect(() => {
        getDoctors(auth.uid);
    },[]);
    return (
        <div>
            <Container>
            <Row lg={3}>
            {doctorSearch.doctors && doctorSearch.doctors.map(doctor => (
                <Col>
                <div key={doctor.email}>
                <Card hoverable={true} style={{ width: '20rem', marginTop:"40px" }}>
                    <Card.Img variant="top" src={doctor.profilePic} rounded />
                    <Card.Body>
                    <Card.Title>Dr. {doctor.name}</Card.Title>
                    <Card.Text>
                        <p><strong>Clinic Address:</strong> {doctor.clinicAddress}</p>
                        <p><strong>Phone Number:</strong> {doctor.phoneNumber}</p>
                        <p><strong>Email:</strong> {doctor.email}</p>
                    </Card.Text>
                    <Button variant="orange"><Link className="text-white" to={`/doctor/consult/${doctor.id}`}>Consult</Link></Button>
                    </Card.Body>
                </Card>
                    
                </div>
                </Col>
            ))}
            </Row>
            </Container>
        </div>
    )
}

const mapStateToProps = (state) => ({
    auth: state.auth,
    doctorSearch: state.doctorSearch
});

const mapDispatchToProps = (dispatch) => ({
    getDoctors: (uid) => dispatch(getDoctors(uid))
});

export default connect(mapStateToProps,mapDispatchToProps)(DoctorSearch);
