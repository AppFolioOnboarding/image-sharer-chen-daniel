/* eslint-env mocha */

import assert from 'assert';
import { shallow } from 'enzyme';
import React from 'react';
import FeedbackForm from '../../components/FeedbackForm';

describe('<FeedbackForm />', () => {
  it('should render correctly', () => {
    const wrapper = shallow(<FeedbackForm />);

    const formGroup1 = wrapper.find('FormGroup').at(0);
    assert.strictEqual(formGroup1.length, 1);
    assert.strictEqual(formGroup1.find('Label').children().text(), 'Your Name');
    assert.strictEqual(formGroup1.find('Input').prop('type'), 'text');

    const formGroup2 = wrapper.find('FormGroup').at(1);
    assert.strictEqual(formGroup2.length, 1);
    assert.strictEqual(formGroup2.find('Label').children().text(), 'Comments');
    assert.strictEqual(formGroup2.find('Input').prop('type'), 'textarea');

    const submitButton = wrapper.find('Button');
    assert.strictEqual(submitButton.length, 1);
    assert.strictEqual(submitButton.children().text(), 'Submit');
  });
});
