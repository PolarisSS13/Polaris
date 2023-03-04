import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, Modal, Section } from '../components';
import { Window } from '../layouts';

export const Bioprinter = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window
      width={450}
      height={90 + 30 * data.products.length}
      resizable scrollable>
      {data.isPrinting && (
        <Modal textAlign="center"
          fontSize={2}
          color="red">
          <Icon name="spinner" spin /> PRINTING...<br /><br />
          <Button
            icon="ban"
            content="Cancel"
            color="red"
            onClick={() => act('cancelPrint')}
          />
        </Modal>
      ) || null}
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
            {!data.biomassContainer
              ? <Box inline color="bad">No biomass container inserted.</Box>
              : <Box inline><b>Stored biomass:</b> {data.biomassVolume}/{data.biomassMax}</Box>}<br />
            {!data.dna
              ? <Box inline color="bad">No DNA sample inserted.</Box>
              : <Box inline><b>DNA sample:</b> {data.dnaSpecies}, {data.dnaHash}</Box>}<br />
            <b>Time to print:</b> {data.printTime / 10} seconds
          </Section>
          <Section title="Printing" scrollable>
            {data.products.map(product => (
              <Flex key={product.name}>
                <Flex.Item basis="33%" grow={1}>
                  <Box inline color={product.anomalous ? "purple" : "label"}>{product.name}</Box>
                </Flex.Item>
                <Flex.Item basis="33%" grow={1}>
                  {product.canPrint
                    ? <Box>{product.cost}/{product.cost}</Box>
                    : <Box>{data.biomassVolume}/{product.cost}</Box>}
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="plus"
                    content="Print"
                    disabled={!product.canPrint}
                    onClick={() => act('printOrgan', {
                      organName: product.name,
                    })}
                  />
                </Flex.Item>
              </Flex>
            ))}
          </Section>
        </Box>
      </Window.Content>
    </Window>
  );
};
