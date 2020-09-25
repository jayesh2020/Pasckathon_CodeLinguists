import React, { useState } from 'react';
import { connect } from 'react-redux';
import { setQuest } from '../../actions/doctorSearch';
import {
  MDBRangeInput,
  MDBRow,
  MDBContainer,
  MDBInput,
  MDBInputGroup,
} from 'mdbreact';

const Questionaire = ({ setQuest,history }) => {
  const [duration, setDuration] = useState('');
  const [severity, setSeverity] = useState('');
  const [timeOf, setTimeOf] = useState([]);
  const [prevMed, setPrevMed] = useState('');
  const [bodyPart, setBodyPart] = useState('');
  const handleInputChange = (event) => {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;
    setTimeOf([...timeOf, event.target.value]);
  };
  return (
    <MDBContainer style={{ maxWidth: 600, marginTop: 20 }}>
      <form>
        <div className='form-group row'>
          <div className='col-sm-9'>
            <MDBInput
              outline
              size='md'
              label='Duration of issue'
              name='duration'
              type='text'
              value={duration}
              className='form-control'
              onChange={(e) => setDuration(e.target.value)}
            />
          </div>
        </div>
        <div className='my-5'>
          <div className='col-sm-9'>
            <label htmlFor='customRange1'>Severity</label>
            <input
              type='range'
              className='custom-range'
              id='serverity'
              min='1'
              max='5'
              step='1'
              onChange={e => setSeverity(e.target.value)}
            />
          </div>
        </div>
        <div className='form-group row'>
          <div className='col-sm-9'>
            <MDBInput
              outline
              size='md'
              label='Previous Medication(Home Remedies)'
              name='prevMed'
              type='text'
              value={prevMed}
              className='form-control'
              onChange={(e) => setPrevMed(e.target.value)}
            />
          </div>
        </div>
        <div className='form-group row'>
          <div className='col-sm-9'>
            <MDBInputGroup
              prepend='Time of day'
              inputs={
                <select
                  className='form-control browser-default custom-select'
                  id='Time of day'
                  value={timeOf}
                  onChange={(e) => setTimeOf(e.target.value)}
                >
                  <option value='Early Morning'>Early Morning</option>
                  <option value='Afternoon'>Afternoon</option>
                  <option value='Evening'>Evening</option>
                  <option value='Night'>Night</option>
                </select>
              }
            />
          </div>
        </div>
        <div className='form-group row'>
          <div className='col-sm-9'>
            <MDBInput
              outline
              size='md'
              label='Which part of Body'
              name='bodypart'
              type='text'
              value={bodyPart}
              className='form-control'
              onChange={(e) => setBodyPart(e.target.value)}
            />
          </div>
        </div>
        <button className="btn btn-primary"
          onClick={(e) => {
            e.preventDefault();
            setQuest({ duration, severity, prevMed, timeOf, bodyPart });
            history.push('/doctorsearch');
          }}
        >
          Submit
        </button>
      </form>
    </MDBContainer>
  );
};

export default connect(null, { setQuest })(Questionaire);
