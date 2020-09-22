import React, { useState } from 'react';
import { setDoctorInfo,setDoctorUser } from '../../actions/info';
import { connect } from 'react-redux';

const DoctorsInfo = ({ auth,info,setDoctorUser,setDoctorInfo }) => {
  const [clinicAddress, setAddress] = useState('');
  const [experience, setExperience] = useState('');
  const [qualification, setQualifications] = useState('');
  const [startTime, setStartTime] = useState('');
  const [endTime, setEndTime] = useState('');
  const [registrationNumber,setReg] = useState('');
  const [clinicSince,setCli] = useState('');

  const onSubmit = (e) => {
    e.preventDefault();
    const doctor = {
      clinicAddress,
      experience,
      qualification,
      startTime,
      endTime,
      //profilePicture,
      clinicSince,
      registrationNumber
    };
    setDoctorInfo(doctor);
    const data = {
      ...doctor,
      ...info.personalInfo,
      email: auth.user.email
    }
    console.log(auth.uid);
    setDoctorUser({data,uid: auth.uid});
    setAddress('');
    setExperience('');
    setQualifications('');
    setStartTime('');
    setEndTime('');
    setCli('');
    setReg('');
    //setProfilePicture('');
  };
  return (
    <div>
      <form>
        <div>
          <input
            type='text'
            value={clinicAddress}
            onChange={(e) => setAddress(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={experience}
            onChange={(e) => setExperience(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={registrationNumber}
            onChange={(e) => setReg(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={clinicSince}
            onChange={(e) => setCli(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={qualification}
            onChange={(e) => setQualifications(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={startTime}
            onChange={(e) => setStartTime(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={endTime}
            onChange={(e) => setEndTime(e.target.value)}
          />
        </div>
        <button onClick={onSubmit}>Next</button>
      </form>
    </div>
  );
};

const mapStateToProps = state => ({
  info : state.info,
  auth: state.auth
});

const mapDispatchToProps = (dispatch) => ({
  setDoctorInfo: (patient) => dispatch(setDoctorInfo(patient)),
  setDoctorUser: (data) => dispatch(setDoctorUser(data))
});

export default connect(mapStateToProps,mapDispatchToProps)(DoctorsInfo);
