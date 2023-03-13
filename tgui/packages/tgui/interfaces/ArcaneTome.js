import { Fragment } from 'inferno';
import { useBackend, useSharedState } from '../backend';
import { Box, Button, Collapsible, Flex, Icon, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const ArcaneTome = (props, context) => {
  const { act, data } = useBackend(context);
  const [tabIndex, setTabIndex] = useSharedState(context, 'tabIndex', 0);
  const [compactMode, setCompactMode] = useSharedState(context, 'compactMode', 0);

  return (
    <Window
      width={500}
      height={600}
      theme="spooky"
      resizable scrollable>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={tabIndex === 0}
            onClick={() => { act("turnPage"); setTabIndex(0); }}>
            Archives
          </Tabs.Tab>
          <Tabs.Tab
            selected={tabIndex === 1}
            onClick={() => { act("turnPage"); setTabIndex(1); }}>
            Runes
          </Tabs.Tab>
        </Tabs>
        <Section>
          {
            tabIndex === 0
            && (
              <Box>
                <i>You are a cultist of <b>Nar-Sie</b>, the One who Sees, the Geometer of Blood.
                  It has revealed to you the fact of Its existence by necessity, and graciously inducted
                  you into Its followers so that you may better serve Its will.
                </i>
                <br /><br />
                <i>These archives serve as an <b>out-of-character</b> knowledge base for information
                  about the cult, how your abilities work, and your ultimate goals. Refer back to it
                  any time you are lost!
                </i><br /><br />
                <Collapsible
                  title="What is this?">
                  You are holding an <b>arcane tome</b>, a book that contains the rites and scriptures of the
                  Geometer. <b>Every cultist should have a tome unless they have a good reason not to.</b>
                  In addition to this informational page, you can browse <b>Runes</b> within a dedicated
                  section of the tome, allowing you to see their functions or scribe them onto the ground.
                  <br /><br />
                  If need be, your tome can serve as a weapon as well. Simply switch to Harm intent and
                  attack your foes with it to deal burn damage. Naturally, it will be abundantly obvious
                  to the target that you are doing something otherworldly and very harmful.
                </Collapsible>
                <Collapsible
                  title="What are runes?">
                  <b>Runes</b> are eldritch scrawlings, etched with precise shapes and words to invoke the power
                  of Nar-Sie. They are the primary source of your power as a cultist, and they allow you to
                  perform anomalous feats alike to magic. Some runes can be made into <b>talismans</b>
                  that offer something akin to their abilities in a more portable form.
                  <br /><br />
                  There are many different types of rune, each with their own functions and methods of use.
                  In order to create a rune, you use your own blood, meaning that you will take a small amount
                  of damage each time you create one. To invoke a rune, simply click on it with an empty hand.
                  <br /><br />
                  Runes are naturally very conspicuous, and you should be careful to keep them well-hidden
                  to avoid drawing unnecessary suspicion. You can erase a rune by clicking on it with your tome
                  - leaving no trace of its existence - or just mop it up like any regular spill.
                  <br /><br />
                  Notably, AIs cannot t perceive runes. Instead, they just see them as a regular pool of blood.
                  That is still conspicuous in its own right, mind you!
                </Collapsible>
                <Collapsible
                  title="What are talismans?">
                  Runes are essential for success, but they can be difficult to lay down quickly. <b>Talismans</b>
                  can be of use there; by invoking the <i>Imbue Talisman</i> rune with a blank sheet of paper on top
                  and a relevant rune nearby, that rune can be inscribed onto the paper, which can then be consumed
                  at any time to mirror its effects.
                  <br /><br />
                  The effects of talismans are usually equivalent to that of their respective rune, but weaker.
                  Some, however, can be vastly different; the Stun talisman, for instance, causes a heavy stun
                  to a single target struck with the talisman, instead of disorienting everyone nearby.
                  Cultists starting aboard the station are equipped with a special Supply talisman that
                  allows them to make certain talismans for free or to create soul shards and construct shells.
                </Collapsible>
                <Collapsible
                  title="What should I do?">
                  Depends! Stealth and infiltration are your best ally, so unless you have already been ousted,
                  it is never a bad idea to simply go back to what you were doing as if nothing had transpired.
                  You can keep in touch with other cultists across distances and z-levels by using a
                  <i>Communicate</i> rune, and coordinating in this manner is very important.
                  <br /><br />
                  When you feel ready to introduce more people to the fold, you should go about it carefully.
                  The <i>Convert</i> rune is opt-in - the convertee can simply keep refusing to join the cult and
                  will take increasing damage instead - so above all else, remember to <b>roleplay</b> and make it
                  an interesting experience. Avoid just stunning someone and dragging them to the rune - lead
                  up to it. Talk to them, manipulate them. Make their conversion <i>mean</i> something.
                </Collapsible>
              </Box>
            )
            || tabIndex === 1
            && (
              <Flex
                direction="column">
                <Button.Checkbox
                  inline
                  content="Compact mode"
                  checked={compactMode}
                  onClick={() => setCompactMode(!compactMode)} /><br />
                {!compactMode
                  && (
                    <Box>
                      {data.runes.map(entry => (
                        <Flex.Item key={entry.name} mb={1}>
                          <Section title={entry.name}>
                            {entry.invokers > 1
                              && (<Fragment><i>Required invokers:</i> {entry.invokers}<br /><br /></Fragment>) || ""}
                            {entry.talisman
                              && (<Fragment><i>Can be made into a talisman</i><br /><br /></Fragment>) || ""}
                            {entry.shorthand}<br /><br />
                            <Button
                              textAlign="center"
                              content="Scribe"
                              onClick={() => act("writeRune", { runePath: entry.typepath })}
                            />
                          </Section>
                        </Flex.Item>
                      ))}
                    </Box>)
                  || (
                    <Box align="center">
                      <i>Entries marked with an asterisk (*) can be made into a talisman.</i><br /><br />
                      {data.runes.map(entry => (
                        <Flex.Item key={entry.name} mb={1}>
                          <Button
                            content={(entry.talisman && entry.name + " *" || entry.name)
                              + (entry.invokers > 1 && " (" + entry.invokers + " invokers)" || "")}
                            tooltip={entry.shorthand}
                            onClick={() => act("writeRune", { runePath: entry.typepath })} />
                        </Flex.Item>
                      ))}
                    </Box>)}
              </Flex>
            )
            || null
          }
        </Section>
      </Window.Content>
    </Window>
  );
};
