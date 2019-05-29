import React from 'react';
import { Container, Form, FormGroup, Label, Input, Button } from 'reactstrap';


export default function FeedbackForm() {
  return (
    <Container>
      <Form>
        <FormGroup>
          <Label for="feedbackName">Your Name</Label>
          <Input type="text" name="name" id="feedbackName" />
        </FormGroup>
        <FormGroup>
          <Label for="feedbackComments">Comments</Label>
          <Input type="textarea" name="comments" id="feedbackComments" />
        </FormGroup>
        <Button color="primary">Submit</Button>
      </Form>
    </Container>
  );
}
