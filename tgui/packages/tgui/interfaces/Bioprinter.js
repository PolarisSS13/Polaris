import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Modal, Section } from '../components';
import { Window } from '../layouts';

export const Bioprinter = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window
      width={450}
      height={150 + 30 * data.products.length}
      resizable>
      {data.isPrinting && (
        <Modal textAlign="center"
          fontSize={2}
          color="red">
          WORKING...<br />
          <Button
            icon="ban"
            content="Cancel"
            color="red"
            onClick={() => act('cancelPrint')}
          />
        </Modal>
      )}
      <Window.Content>
        <Box>
          <Section title="Summary" buttons={(
            <Fragment>
              <Button
                icon="trash-alt"
                content="Flush DNA Sample"
                disabled={!data.dna}
                onClick={() => act('flushDNA')}
              />
              <Button
                icon="eject"
                content="Eject Container"
                disabled={!data.biomassContainer}
                onClick={() => act('ejectBeaker')}
              />
            </Fragment>
          )}>
            {!data.biomassContainer ? <Box inline color="bad">No biomass container inserted.</Box>
              : <Box inline><b>Stored biomass:</b> {data.biomassVolume}/{data.biomassMax}</Box>}<br />
            {!data.dna ? <Box inline color="bad">No DNA sample inserted.</Box>
              : <Box inline>
                <b>DNA hash:</b> {data.dnaHash}<br />
                <b>DNA species:</b> {data.dnaSpecies}<br />
              </Box>}<br />
            <b>Time to print:</b> {data.printTime / 10} seconds
          </Section>
          <Section title="Printing">
            <LabeledList>
              {data.products.map(product => (
                <LabeledList.Item
                  className="candystripe"
                  label={product.name}
                  labelColor={product.anomalous ? "purple" : "label"}
                  buttons={(
                    <Button
                      icon="plus"
                      content="Print"
                      disabled={!product.canPrint}
                      onClick={() => act('printOrgan', {
                        organName: product.name,
                      })}
                    />
                  )}>
                  {product.canPrint ? <Box>{product.cost}/{product.cost}</Box> : <Box>{data.biomassVolume}/{product.cost}</Box>}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Box>
      </Window.Content>
    </Window>
  );
};
